# frozen_string_literal: true

RSpec.describe(HTTP::Auth0) do
  it "has a version number" do
    expect(HTTP::Auth0::VERSION).to(be_a(String))
  end
end
