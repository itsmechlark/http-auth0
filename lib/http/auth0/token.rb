# frozen_string_literal: true

require "json"
require "jwt"
require "net/http"
require "openssl"
require "uri"

module HTTP
  class Auth0
    class ConfigurationError < StandardError; end

    class << self
      def token(aud:)
        validate_configuration(key: :client_id)
        validate_configuration(key: :client_secret)

        if (cached = access_tokens[aud])
          return cached unless expired?(token: cached)
        end
        request_access_token(aud: aud)
      end

      private

      def access_tokens
        @access_tokens ||= {}
      end

      def validate_configuration(key:)
        raise ConfigurationError, "Missing #{key} in configuration" if [nil, ""].any?(config.send(key))
      end

      def expired?(token:)
        decoded_token = JWT.decode(token, nil, false)
        payload = decoded_token.first
        expiration = payload["exp"]
        current_time = Time.now.to_i
        seconds_before_refresh = config.seconds_before_refresh
        expiration_time = Time.at(expiration).to_i - seconds_before_refresh.to_i

        current_time >= expiration_time
      rescue StandardError => e
        config.logger.error(e)
        true
      end

      def request_access_token(aud:)
        url = URI("#{issuer}/oauth/token")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Post.new(url)
        request["content-type"] = "application/x-www-form-urlencoded"

        body = request_body(aud: aud)
        request.body = body.map { |key, value| "#{key}=#{value}" }.join("&")

        response = http.request(request)
        body = response.read_body

        case response
        when Net::HTTPSuccess
          auth0_response = JSON.parse(body)
          auth0_response["access_token"].tap do |access_token|
            access_tokens[aud] = access_token
          end
        else
          config.logger.warn("#{response.message}: #{body}")
          nil
        end
      end

      def request_body(aud:)
        {
          audience: aud,
          client_id: config.client_id,
          client_secret: config.client_secret,
          grant_type: "client_credentials",
        }
      end

      def issuer
        "https://#{config.custom_domain || config.domain}"
      end
    end
  end
end
