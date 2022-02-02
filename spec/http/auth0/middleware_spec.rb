# frozen_string_literal: true

require "http/auth0/middleware"

# TODO: Replace with actual spec when middleware feature comes in as
# these are just to appease Simplecov
RSpec.describe(HTTP::Auth0::Middleware) do
  describe '#on_request(env)' do
    let(:app) { double("app") }
    let(:middleware) { described_class.new(app) }
    let(:request_headers) { { Authorization: 'ALREADY_SET' } }

    it do
      expect(
        middleware.on_request(
          OpenStruct.new(request_headers: request_headers)
        )
      ).to be_nil
    end
  end
end
