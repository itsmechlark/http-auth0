# frozen_string_literal: true

require "dry/configurable"

module HTTP
  class Auth0
    extend(Dry::Configurable)

    setting(:client_id)
    setting(:client_secret)
    setting(:domain)
  end
end

require_relative "auth0/version"
