# frozen_string_literal: true

module CustomerioRails
  class Railtie < Rails::Railtie
    initializer 'customerio-rails', :before => 'action_mailer.set_configs' do
      ActiveSupport.on_load :action_mailer do
        CustomerioRails.install
      end
    end
  end
end
