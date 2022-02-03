# frozen_string_literal: true

RSpec.describe(HTTP::Auth0) do
  let(:client_id)     { "CLIENT_ID" }
  let(:client_secret) { "CLIENT_SECRET" }
  let(:domain)        { "firstcircle.ph" }

  before { described_class.reset_config }

  it "has a version number" do
    expect(HTTP::Auth0::VERSION).to(be_a(String))
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

      it { expect(described_class.config.client_id).to(eq(client_id)) }
      it { expect(described_class.config.client_secret).to(eq(client_secret)) }
      it { expect(described_class.config.domain).to(eq(domain)) }
    end
  end

  context "when configuring using .config" do
    describe ".config" do
      before do
        described_class.config.client_id      = client_id
        described_class.config.client_secret  = client_secret
        described_class.config.domain         = domain
      end

      it { expect(described_class.config.client_id).to(eq(client_id)) }
      it { expect(described_class.config.client_secret).to(eq(client_secret)) }
      it { expect(described_class.config.domain).to(eq(domain)) }
    end
  end
end
