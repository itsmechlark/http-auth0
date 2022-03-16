# http-auth0

[![CI](https://github.com/carabao-capital/http-auth0/actions/workflows/release.yml/badge.svg)](https://github.com/carabao-capital/http-auth0/actions/workflows/release.yml)

HTTP client abstraction layer for Auth Application [RFC](https://github.com/carabao-capital/rfcs/pull/2)

## Installation

Add these lines to your application's Gemfile:

```ruby
source 'https://rubygems.pkg.github.com/carabao-capital' do
  gem 'http-auth0'
end
```

And then execute:
```bash
$ bundle
```

## Usage

### Configure the gem in an initializer

```ruby
HTTP::Auth0.configure do |auth0|
  auth0.domain = 'insert-domain-here.jp.auth0.com'
  auth0.client_id = 'insert-client-id-here'
  auth0.client_secret = 'insert-client-secret-here'
end
```

### Use with your preferred HTTP client
#### Faraday Example

```ruby
require 'faraday'
require 'faraday/net_http'
require 'http/auth0/middleware'

conn = Faraday.new do |f|
  f.use HTTP::Auth0::Middleware
end

conn.post("https://staging-01.api.connect.my.firstcircle.ph/graphql")
```

#### Net::HTTP Example

```ruby
require 'http/auth0'
require 'net/http'    

uri = URI("https://staging-01.api.connect.my.firstcircle.ph/graphql")
req = Net::HTTP::Get.new(uri)
req['Authorization'] = HTTP::Auth0.token(aud: uri.to_s)

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

puts res.body
```

## Dependencies

- [Auth0](https://auth0.com/)
- [dry-configurable](https://github.com/dry-rb/dry-configurable)
- [ruby-jwt](https://github.com/jwt/ruby-jwt)

## Contributing

1. Clone the [http-auth0 repo](https://github.com/carabao-capital/http-auth0)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
