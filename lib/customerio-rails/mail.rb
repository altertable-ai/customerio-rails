# frozen_string_literal: true

module CustomerioRails
  module Mail
    class Customerio
      attr_accessor :settings
  
      def initialize(values)
        self.settings = {
          region: ENV['CUSTOMERIO_REGION'] || ::Customerio::Regions::US,
          app_api_key: ENV['CUSTOMERIO_APP_API_KEY']
        }.merge(values)
      end
  
      def deliver!(mail)
        Array.wrap(mail.to).each do |to|
          request = ::Customerio::SendEmailRequest.new({
            to: to,
            from: Array.wrap(mail.from).first,
            subject: mail.subject,
            body: mail.body,
            reply_to: mail.reply_to,
            cc: mail.cc,
            bcc: mail.bcc,
            headers: mail.headers,
            identifiers: { email: to } 
          }.compact)
          mail.attachments.each do |attachment|
            request.attach(attachment.filename, attachment.read)
          end
          api_client.send_email(request)
        end
      end
  
      def api_client
        ::Customerio::APIClient.new(settings[:app_api_key], region: settings[:region])
      end
    end
  end
end
