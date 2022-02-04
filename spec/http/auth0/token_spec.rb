# frozen_string_literal: true

RSpec.describe("HTTP::Auth0") do
  subject(:described_class) { HTTP::Auth0 }

  let(:client_id)     { "CLIENT_ID" }
  let(:client_secret) { "CLIENT_SECRET" }
  let(:domain)        { "firstcircle.ph" }

  before { described_class.reset_config }

  describe ".token(aud:)" do
    let(:aud) { "https://api.firstcircle.ph" }

    before do
      described_class.config.client_id      = client_id
      described_class.config.client_secret  = client_secret
      described_class.config.domain         = domain
    end

    context "when client_id is nil" do
      before { described_class.config.client_id = nil }

      it do
        expect { described_class.token(aud: aud) }.to(raise_error(
          an_instance_of(HTTP::Auth0::ConfigurationError)
            .and(having_attributes(message: "Missing client_id in configuration"))
        ))
      end
    end

    context "when client_secret is nil" do
      before { described_class.config.client_secret = nil }

      it do
        expect { described_class.token(aud: aud) }.to(raise_error(
          an_instance_of(HTTP::Auth0::ConfigurationError)
            .and(having_attributes(message: "Missing client_secret in configuration"))
        ))
      end
    end

    context "when client id and secret are provided" do
      let(:access_token) do
        "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImRKbzFsM3owOEo0REUyVWQ3R"\
          "HJybiJ9.eyJpc3MiOiJodHRwczovL2Rldi1xNGg1dnhnbS5qcC5hdXRoMC5jb20vIiwic"\
          "3ViIjoiUWVFR292OURSSjNjTnhGOFNZdXkwMUhnM1JlSHRQeDlAY2xpZW50cyIsImF1ZC"\
          "I6Imh0dHBzOi8vc3RhZ2luZy0wMS5hcGkuY29ubmVjdC5teS5maXJzdGNpcmNsZS5waC9"\
          "ncmFwaHFsIiwiaWF0IjoxNjQzODgxMjU1LCJleHAiOjE2NDM5Njc2NTUsImF6cCI6IlFl"\
          "RUdvdjlEUkozY054RjhTWXV5MDFIZzNSZUh0UHg5IiwiZ3R5IjoiY2xpZW50LWNyZWRlb"\
          "nRpYWxzIiwicGVybWlzc2lvbnMiOltdfQ.gQ62J6XAEw2g-ROgImooWLmYLZwzRHd2S6O"\
          "1fMM3MIui30qExQ8ZFD9eAcVDzfb6PFBYsyEBsK_dM6htYiE36jUYNHRy7_I1uFAYLpBb"\
          "_gNmgSUNHZkoZCzSnlD7GS-qojFy1Zyq3vCxD_qbCNqz0NlI1t7s-OIBN2gF3w9mwSUWt"\
          "JU04KLdSyWU3r928vAHlkYwgDnfNUzPqljOJueZs3gMTdKYR1V_72dycgs_DtqGyCtTd_"\
          "wEN1q_RALEPeCqQQ9YMZA5cW5x6HXy2YTbWJLNGj5n4yxJzeDhGsDLw9GgWc9WYAIT6Bv"\
          "b-Z9qdiCHCcOY_16y1h8iCESDfRKX4A"
      end

      before do
        stub_request(:post, "https://firstcircle.ph/oauth/token")
          .with(
            body: {
              "audience" => "https://api.firstcircle.ph",
              "client_id" => "CLIENT_ID",
              "client_secret" => "CLIENT_SECRET",
              "grant_type" => "client_credentials",
            },
            headers: {
              "Accept" => "*/*",
              "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "Content-Type" => "application/x-www-form-urlencoded",
              "Host" => "firstcircle.ph",
              "User-Agent" => "Ruby",
            }
          )
          .to_return(
            status: 200,
            body: "{\"access_token\":\"#{access_token}\",\"expires_in\":86400,\"token_type\":\"Bearer\"}",
            headers: {}
          )
      end

      it { expect(described_class.token(aud: aud)).to(eq(access_token)) }

      it "does not send multiple request for access token when it got one" do
        described_class.token(aud: aud)
        # rubocop:disable RSpec/MessageSpies, RSpec/SubjectStub
        expect(described_class).not_to(receive(:request_access_token))
        # rubocop:enable RSpec/MessageSpies, RSpec/SubjectStub
        described_class.token(aud: aud)
      end
    end
  end
end
