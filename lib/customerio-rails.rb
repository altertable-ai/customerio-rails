# frozen_string_literal: true

require 'active_support/rescuable'
require 'action_mailer'
require 'customerio'

module CustomerioRails
  module WithTemplatedMessageMailer
    def mail(*args, **kwargs)
      if kwargs[:transactional_message_id].present?
        # force a blank body to avoid looking for a template locally
        kwargs[:body] = ''
      end
      super
    end
  end

  def self.install
    require 'customerio-rails/mail'
    ActionMailer::Base.add_delivery_method :customerio, CustomerioRails::Mail::Customerio
    ActionMailer::Base.prepend(WithTemplatedMessageMailer)
  end
end

if defined?(Rails)
  require 'customerio-rails/railtie'
else
  CustomerioRails.install
end
