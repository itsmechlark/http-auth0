# frozen_string_literal: true

require "faker"

ENV["AUTH0_CLIENT_ID"] ||= Faker::Internet.unique.password
ENV["AUTH0_CLIENT_SECRET"] ||= Faker::Internet.unique.password
ENV["AUTH0_DOMAIN"] ||= Faker::Internet.domain_name(subdomain: true)

require "faraday"
# This is the magic bit. It requires a tests suite from the Faraday gem that you can run against your adapter
require "faraday_specs_setup"
require "simplecov"
require "dry/configurable/test_interface"
require "timecop"

require "http/auth0"

SimpleCov.start do
  add_filter "/spec/"
  minimum_coverage 95
  minimum_coverage_by_file 90
end

module HTTP
  class Auth0
    enable_test_interface
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.order = :random
end
