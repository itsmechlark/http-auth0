# frozen_string_literal: true

module HTTP
  class Auth0
    VERSION = "1.0.1"

    class << self
      def gem_version
        Gem::Version.new(VERSION)
      end
    end
  end
end
