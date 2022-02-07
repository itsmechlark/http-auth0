# frozen_string_literal: true

require "http/auth0/middleware"

RSpec.describe(HTTP::Auth0::Middleware) do
  let(:auth0) { HTTP::Auth0 }

  describe "#on_request(env)" do
    let(:app) { instance_double("app") }
    let(:middleware) { described_class.new(app) }

    context "when Authorization header is set" do
      let(:request_headers) { { "Authorization" => "ALREADY_SET" } }

      it do
        expect(
          middleware.on_request(
            Struct.new(:request_headers).new(request_headers)
          )
        ).to(be_nil)
      end
    end

    context "when Authorization header is not set" do
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
      let(:env) do
        Struct.new(:request_headers, :url).new(
          {},
          URI("https://api.firstcircle.ph")
        )
      end

      before do
        auth0.config.client_id      = "CLIENT_ID"
        auth0.config.client_secret  = "CLIENT_SECRET"
        auth0.config.domain         = "firstcircle.ph"

        Timecop.freeze(Time.at(1643881255))
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

      it { expect(middleware.on_request(env)).not_to(be_nil) }

      it do
        middleware.on_request(env)
        expect(env.request_headers["Authorization"]).to(eq("Bearer #{access_token}"))
      end
    end
  end
end
