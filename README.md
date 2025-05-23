# Customer.io Rails Gem

[![License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://www.opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/customerio-rails.svg)](https://badge.fury.io/rb/customerio-rails)

The `customerio-rails` gem is a drop-in ActionMailer adapter to send emails via [Customer.io](https://customer.io).
The gem has been created for fast implementation and targets Customer.io’s transactional email capabilities.

## Usage

## Requirements

You will need a [Customer.io](https://customer.io/) account set up to use it.

### Supported Rails Versions

- Rails 8.0
- Rails 7.0

### App API Key

Generate an **App API Key** (this is different than the pair _Site ID_ / _API Key_) from your _Workspace Settings_ > Your Workspace > _Manage API Credentials_ > _App API Keys_.

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

## Usage

Use it as you would usually:

```ruby
class MyMailer < ApplicationMailer
  def whatever # whatever.{html,text}.erb will be used as body
    mail to: 'someone@somewhere.com', subject: 'Hello from Rails!'
  end
end
```

Or rely on Customer.io's templated messages with:

```ruby
class MyMailer < ApplicationMailer
  def whatever_with_template
    mail to: 'someone@somewhere.com', subject: 'Hello from Rails!', transactional_message_id: 3, message_data: { myvar: 'a value', another_one: 42x }
  end
end
```

## License

The Customer.io Rails gem is licensed under the [MIT](http://www.opensource.org/licenses/mit-license.php) license.
Refer to the [LICENSE](./LICENSE) file for more information.
