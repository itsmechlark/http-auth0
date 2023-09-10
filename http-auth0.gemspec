# frozen_string_literal: true

require_relative "lib/http/auth0/version"

Gem::Specification.new do |s|
  s.name = "http-auth0"
  s.version = HTTP::Auth0.gem_version
  s.authors = ["John Chlark Sumatra"]
  s.email = ["clark@sumatra.com.ph"]

  s.summary = "Faraday adapter for Auth0"
  s.description = "Faraday adapter for Auth0"
  s.homepage = "https://github.com/itsmechlark/http-auth0"
  s.license = "MIT"

  s.required_ruby_version = Gem::Requirement.new(">= 2.7")

  s.metadata = {
    "homepage_uri" => s.homepage,
    "changelog_uri" => "https://github.com/itsmechlark/http-auth0/releases/tag/v#{s.version}",
    "source_code_uri" => "https://github.com/itsmechlark/http-auth0/tree/v#{s.version}",
    "bug_tracker_uri" => "https://github.com/itsmechlark/http-auth0/issues",
    "github_repo" => "https://github.com/itsmechlark/http-auth0",
  }

  s.files = Dir.glob("lib/**/*") + ["README.md", "LICENSE.md"]
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["LICENSE.md", "README.md"]

  s.add_dependency("activesupport", ">= 5.2")
  s.add_dependency("dry-configurable", "~> 0.14")
  s.add_dependency("jwt", "~> 2.3.0")

  s.add_development_dependency("faraday", "~> 2.0")

  s.add_development_dependency("bundler", "~> 2.0")
  s.add_development_dependency("code-scanning-rubocop")
  s.add_development_dependency("faker", "~> 2.0")
  s.add_development_dependency("multipart-parser", "~> 0.1.1")
  s.add_development_dependency("pry-byebug", "~> 3.7")
  s.add_development_dependency("rake", "~> 13.0")
  s.add_development_dependency("rspec", "~> 3.0")
  s.add_development_dependency("rubocop-performance")
  s.add_development_dependency("rubocop-rake")
  s.add_development_dependency("rubocop-rspec")
  s.add_development_dependency("rubocop-shopify", "~> 2.14")
  s.add_development_dependency("simplecov", "~> 0.19.0")
  s.add_development_dependency("timecop", "~> 0.9.4")
  s.add_development_dependency("vcr", "~> 6.0")
  s.add_development_dependency("webmock", "~> 3.4")
end
