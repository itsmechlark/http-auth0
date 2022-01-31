# frozen_string_literal: true

require "dry/configurable"

module HTTP
  class Auth0
    extend Dry::Configurable
  end
end

require_relative "auth0/version"
