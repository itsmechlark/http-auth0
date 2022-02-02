# frozen_string_literal: true

require "dry/configurable"

module HTTP
  class Auth0
    module Configuration
      def self.included(base)
        base.extend(Dry::Configurable)

        base.class_eval do
          setting(:client_id)
          setting(:client_secret)
          setting(:domain)
        end
      end
    end
  end
end
