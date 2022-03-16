# frozen_string_literal: true

RSpec.describe(HTTP::Auth0) do
  subject(:config) { described_class.config }

  let(:client_id)     { Faker::Internet.unique.password }
  let(:client_secret) { Faker::Internet.unique.password }
  let(:domain)        { Faker::Internet.domain_name(subdomain: true) }

  before { described_class.reset_config }

  it "defaults to ENV['AUTH0_CLIENT_ID'] for client_id" do
    expect(config.client_id).to(eq(ENV["AUTH0_CLIENT_ID"]))
  end

  it "defaults to ENV['AUTH0_CLIENT_SECRET'] for client_secret" do
    expect(config.client_secret).to(eq(ENV["AUTH0_CLIENT_SECRET"]))
  end

  it "defaults to ENV['AUTH0_DOMAIN'] for domain" do
    expect(config.domain).to(eq(ENV["AUTH0_DOMAIN"]))
  end

  context "when configuring by passing a config block" do
    describe ".configure(&config)" do
      before do
        described_class.configure do |config|
          config.client_id      = client_id
          config.client_secret  = client_secret
          config.domain         = domain
        end
      end

      it { expect(config.client_id).to(eq(client_id)) }
      it { expect(config.client_secret).to(eq(client_secret)) }
      it { expect(config.domain).to(eq(domain)) }
      it { expect(config.logger).to(be_an_instance_of(Logger)) }
      it { expect(config.seconds_before_refresh).to(eq(60)) }
    end
  end

  context "when configuring using .config" do
    describe ".config" do
      before do
        config.client_id      = client_id
        config.client_secret  = client_secret
        config.domain         = domain
      end

      it { expect(config.client_id).to(eq(client_id)) }
      it { expect(config.client_secret).to(eq(client_secret)) }
      it { expect(config.domain).to(eq(domain)) }
      it { expect(config.logger).to(be_an_instance_of(Logger)) }
      it { expect(config.seconds_before_refresh).to(eq(60)) }
    end
  end
end
