# frozen_string_literal: true

require_relative "auth0/configuration"
require_relative "auth0/version"

module HTTP
  class Auth0
    include Configuration
  end
end
