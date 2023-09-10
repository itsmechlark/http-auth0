# frozen_string_literal: true

require "http/auth0/middleware"

RSpec.describe(HTTP::Auth0::Middleware) do
  let(:auth0) { HTTP::Auth0 }

  describe "#on_request(env)" do
    let(:app) { instance_double("app") } # rubocop:disable RSpec/VerifiedDoubleReference
    let(:middleware) { described_class.new(app) }

    context "when Authorization header is set" do
      let(:request_headers) { { "Authorization" => "ALREADY_SET" } }

      it do
        expect(
          middleware.on_request(
            Struct.new(:request_headers).new(request_headers),
          ),
        ).to(be_nil)
      end
    end

    context "when Authorization header is not set" do
      let(:env) do
        Struct.new(:request_headers, :url).new(
          {},
          URI("https://example.com"),
        )
      end

      it "process request" do
        VCR.use_cassette("auth0/token") do
          expect(middleware.on_request(env)).not_to(be_nil)
        end
      end

      it "adds authorization header" do
        VCR.use_cassette("auth0/token") do
          middleware.on_request(env)
        end
        expect(env.request_headers["Authorization"]).to(include("Bearer"))
      end
    end
  end
end
