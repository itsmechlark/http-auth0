# frozen_string_literal: true

require "dry/configurable"
require_relative "auth0/token"

module HTTP
  class Auth0
    extend(Dry::Configurable)

    setting(:client_id, default: ENV["AUTH0_CLIENT_ID"])
    setting(:client_secret, default: ENV["AUTH0_CLIENT_SECRET"])
    setting(:domain, default: ENV["AUTH0_DOMAIN"])
    setting(:logger, default: Logger.new(STDOUT))
    setting(:seconds_before_refresh, default: 60)
  end
end

require_relative "auth0/version"
