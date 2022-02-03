# frozen_string_literal: true

require "uri"
require "net/http"
require "openssl"
require "json"

module HTTP
  class Auth0
    class ConfigurationError < StandardError; end

    class << self
      def token(aud:)
        validate_configuration(key: :client_id)
        validate_configuration(key: :client_secret)

        request_access_token(aud: aud)
      end

      private

      attr_accessor :access_token

      def validate_configuration(key:)
        raise ConfigurationError, "Missing #{key} in configuration" if [nil, ""].any?(config.send(key))
      end

      def request_access_token(aud:)
        url = URI("https://#{config.domain}/oauth/token")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["content-type"] = "application/x-www-form-urlencoded"

        body = request_body(aud: aud)
        request.body = body.map { |key, value| "#{key}=#{value}" }.join("&")

        response = http.request(request)
        body = response.read_body
        auth0_response = JSON.parse(body)
        @access_token = auth0_response["access_token"]
        puts "body: #{body}"
        puts "auth0_response: #{auth0_response}"
        puts "access_token: #{access_token}"

        access_token
      end

      def request_body(aud:)
        {
          grant_type: "client_credentials",
          client_id: config.client_id,
          client_secret: config.client_secret,
          audience: aud,
        }
      end
    end
  end
end
