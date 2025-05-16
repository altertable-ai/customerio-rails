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
          params = {
            to: to,
            from: Array.wrap(mail[:from]).first.unparsed_value,
            subject: mail.subject,
            reply_to: mail.reply_to,
            bcc: mail.bcc,
            headers: mail.headers,
            identifiers: { email: to } 
          }
          if mail[:transactional_message_id]
            params[:transactional_message_id] = mail[:transactional_message_id].unparsed_value
            params[:message_data] = mail[:message_data]&.unparsed_value || {}
          else
            params[:body] = mail.html_part.body.to_s if mail.html_part
            params[:body_plain] = mail.text_part.body.to_s if mail.text_part
            if params[:body].blank?
              if mail.text?
                params[:body] = ''
                params[:body_plain] = mail.body.to_s if params[:body_plain].blank?
              else
                params[:body] = mail.body.to_s
              end
            end
          end
          request = ::Customerio::SendEmailRequest.new(params.compact)
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
