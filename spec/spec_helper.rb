# frozen_string_literal: true

require "faker"

ENV["AUTH0_CLIENT_ID"] ||= Faker::Internet.unique.password
ENV["AUTH0_CLIENT_SECRET"] ||= Faker::Internet.unique.password
ENV["AUTH0_DOMAIN"] ||= "auth.test.firstcircle.ph"

require "pry-byebug"
require "faraday"
# This is the magic bit. It requires a tests suite from the Faraday gem that you can run against your adapter
require "faraday_specs_setup"
require "simplecov"
require "dry/configurable/test_interface"
require "timecop"
require "vcr"
require "webmock/rspec"

require "http/auth0"

SimpleCov.start do
  add_filter "/spec/"
  minimum_coverage 95
  minimum_coverage_by_file 90
end

VCR.configure do |config|
  config.default_cassette_options = {
    allow_playback_repeats: true,
    match_requests_on: [:method, :uri],
  }
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.configure_rspec_metadata!
  config.hook_into(:webmock)

  unless ENV.key?("CI")
    config.default_cassette_options.merge(record: :new_episodes)
  end

  [
    "AUTH0_DOMAIN",
    "AUTH0_CUSTOM_DOMAIN",
    "AUTH0_AUDIENCE",
    "AUTH0_CLIENT_ID",
    "AUTH0_CLIENT_SECRET",
  ].each do |var|
    config.filter_sensitive_data("[#{var}]") { ENV[var] }
  end
end

RSpec.configure do |config|
  config.expect_with(:rspec) do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with(:rspec) do |mocks|
    mocks.syntax = :expect
  end

  config.order = :random

  config.before do
    WebMock.reset!
    WebMock.disable_net_connect!
    HTTP::Auth0.enable_test_interface
  end
end
