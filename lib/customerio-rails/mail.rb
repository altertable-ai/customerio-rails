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
        (Array.wrap(mail.to) + Array.wrap(mail.cc)).compact.each do |to|
          request = ::Customerio::SendEmailRequest.new({
            to: to,
            from: Array.wrap(mail.from).first,
            subject: mail.subject,
            body: mail.html_part&.body&.to_s || mail.body.to_s,
            body_plain: mail.text_part&.body&.to_s,
            reply_to: mail.reply_to,
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
