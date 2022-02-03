# frozen_string_literal: true

require "dry/configurable"

module HTTP
  class Auth0
    class ConfigurationError < StandardError; end

    extend(Dry::Configurable)

    setting(:client_id)
    setting(:client_secret)
    setting(:domain)

    class << self
      def token(aud:)
        validate_configuration(key: :client_id)
        validate_configuration(key: :client_secret)

        "IMPLEMENT_ME"
      end

      private

      def validate_configuration(key:)
        raise ConfigurationError, "Missing #{key} in configuration" if [nil, ""].any?(config.send(key))
      end
    end
  end
end

require_relative "auth0/version"
