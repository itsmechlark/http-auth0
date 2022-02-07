# frozen_string_literal: true

require "faraday"

module HTTP
  class Auth0
    # Request middleware for the Auth0 Authorization HTTP header
    class Middleware < Faraday::Middleware
      KEY = "Authorization"

      # @param app [#call]
      def initialize(app)
        super(app)
      end

      # @param env [Faraday::Env]
      def on_request(env)
        return if env.request_headers[KEY]

        env.request_headers[KEY] = "Bearer #{auth0_token(env)}"
      end

      private

      # @param env [Faraday::Env]
      # @return [String] a header value
      def auth0_token(env)
        uri = env.url.to_s
        aud_uri = URI.parse(uri)
        aud_uri.fragment = aud_uri.query = nil
        Auth0.token(aud: aud_uri.to_s)
      end
    end
  end
end

Faraday::Request.register_middleware(auth0: HTTP::Auth0::Middleware)
