# frozen_string_literal: true

require "dry/configurable"
require_relative "auth0/token"

module HTTP
  class Auth0
    extend(Dry::Configurable)

    setting(:client_id)
    setting(:client_secret)
    setting(:domain)
    setting(:seconds_before_refresh, 60)
  end
end

require_relative "auth0/version"
