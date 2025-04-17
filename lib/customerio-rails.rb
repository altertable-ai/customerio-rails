# frozen_string_literal: true

require 'active_support/rescuable'
require 'action_mailer'
require 'customerio'

module CustomerioRails
  def self.install
    require 'customerio-rails/mail'
    ActionMailer::Base.add_delivery_method :customerio, CustomerioRails::Mail::Customerio
  end
end

if defined?(Rails)
  require 'customerio-rails/railtie'
else
  CustomerioRails.install
end
