# frozen_string_literal: true

require "active_support/core_ext/object/blank"
require "dry/configurable"

module HTTP
  class Auth0
    extend(Dry::Configurable)

    setting(:client_id, default: ENV["AUTH0_CLIENT_ID"].presence)
    setting(:client_secret, default: ENV["AUTH0_CLIENT_SECRET"].presence)
    setting(:custom_domain, default: ENV["AUTH0_CUSTOM_DOMAIN"].presence)
    setting(:domain, default: ENV["AUTH0_DOMAIN"].presence)
    setting(:logger, default: Logger.new(STDOUT))
    setting(:seconds_before_refresh, default: 60)
  end
end

require_relative "auth0/token"
require_relative "auth0/version"
