# frozen_string_literal: true

RSpec.describe(HTTP::Auth0::Token) do
  let(:auth0) { described_class.instance }
  let(:aud) { "https://mirror.app.firstcircle.ph" }

  before { auth0.instance_variable_set(:@access_tokens, {}) }

  context "when client_id is nil" do
    before { HTTP::Auth0.config.client_id = nil }

    after { HTTP::Auth0.reset_config }

    it do
      expect { auth0.token(aud: aud) }.to(raise_error(
        an_instance_of(HTTP::Auth0::ConfigurationError)
          .and(having_attributes(message: "Missing client_id in configuration"))
      ))
    end
  end

  context "when client_secret is nil" do
    before { HTTP::Auth0.config.client_secret = nil }

    after { HTTP::Auth0.reset_config }

    it do
      expect { auth0.token(aud: aud) }.to(raise_error(
        an_instance_of(HTTP::Auth0::ConfigurationError)
          .and(having_attributes(message: "Missing client_secret in configuration"))
      ))
    end
  end

  context "when client id and secret are provided" do
    before do
      VCR.use_cassette("auth0/token") do
        auth0.token(aud: aud)
      end
      Timecop.freeze(Time.at(1647413828))
      allow(auth0).to(receive(:request_access_token).and_return("some-token"))
    end

    after { Timecop.return }

    it { expect(auth0.token(aud: aud)).to(be_present) }

    it "returns cached token" do
      expect(auth0).not_to(have_received(:request_access_token))
      auth0.token(aud: aud)
    end

    context "when expired" do
      it "refresh token" do
        Timecop.freeze(Time.at(1648709774))
        auth0.token(aud: aud)
        expect(auth0).to(have_received(:request_access_token))
      end

      it "refresh token after expiration" do
        Timecop.freeze(Time.at(1648709774 + 1))
        auth0.token(aud: aud)
        expect(auth0).to(have_received(:request_access_token))
      end

      it "refresh token when it's expiring relative to seconds_before_refresh" do
        Timecop.freeze(Time.at(1648709774 - 60))
        auth0.token(aud: aud)
        expect(auth0).to(have_received(:request_access_token))
      end
    end
  end
end
