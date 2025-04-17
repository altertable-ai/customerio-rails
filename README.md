# Customer.io Rails Gem

[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://www.opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/customerio-rails.svg)](https://badge.fury.io/rb/customerio-rails)

The Customer.io Rails Gem is a drop-in plug-in for ActionMailer to send emails via [Customer.io](https://customer.io).
The gem has been created for fast implementation and targets Customer.io’s transactional email capabilities.

## Usage

## Requirements

You will need a Customer.io account set up to use it.

### Supported Rails Versions

- Rails 8.0
- Rails 7.0

## Installation

Add `customerio-rails` to your Gemfile and run `bundle install`.

```ruby
gem 'customerio-rails'
```

Set Customer.io as your preferred mail delivery method via `config/application.rb`:

```ruby
config.action_mailer.delivery_method = :customerio
config.action_mailer.customerio_settings = { app_api_key: '<Your APP API Key>', region: Customerio::Regions::US }
```

## License

The Customer.io Rails gem is licensed under the [MIT](http://www.opensource.org/licenses/mit-license.php) license.
Refer to the [LICENSE](./LICENSE) file for more information.
