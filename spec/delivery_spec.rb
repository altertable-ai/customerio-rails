# frozen_string_literal: true

require 'spec_helper'

describe 'Delivering messages with customerio-rails' do
  let(:app_api_key) { 'CUSTOMERIO_APP_API_KEY' }

  before do
    ActionMailer::Base.customerio_settings = { app_api_key: app_api_key }
    response = Net::HTTPSuccess.new(1.0, 200, '{}')
    allow(response).to receive(:body).and_return('{}')
    mocked_http = double('mocked_http')
    allow(mocked_http).to receive(:request).with(satisfy { |request|
      expect(Array.wrap(expected_body)).to include(JSON.parse(request.body))
    }).and_return(response)
    allow_any_instance_of(Net::HTTP).to receive(:start).and_yield(mocked_http)
  end

  context 'when delivering a simple message' do
    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com', 'subject' => 'hello',
        'body_plain' => "hello\n", 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => {} }
    end

    let(:message) { TestMailer.simple_message }

    it do
      message.deliver!
    end

    context 'with a reply-to address' do
      let(:expected_body) do
        super().merge('reply_to' => ['raj@bigbangtheory.com'])
      end

      it do
        message.reply_to = 'raj@bigbangtheory.com'
        message.deliver!
      end
    end

    context 'with a bcc address' do
      let(:expected_body) do
        super().merge('bcc' => ['raj@bigbangtheory.com'])
      end
      
      it do
        message.bcc = 'raj@bigbangtheory.com'
        message.deliver!
      end
    end

    context 'with a cc address' do
      let(:expected_body) do
        [super(), super().merge('to' => 'raj@bigbangtheory.com', 'identifiers' => { 'email' => 'raj@bigbangtheory.com' })]
      end
      
      it do
        message.cc = 'raj@bigbangtheory.com'
        message.deliver!
      end
    end
  end

  context 'when delivering with a nice from address' do
    let(:expected_body) do
      {"to" => "sheldon@bigbangtheory.com", "from" => "Leonard Hofstadter <leonard@bigbangtheory.com>",
        "subject" => "hello", "headers" => {}, "identifiers" => {"email" => "sheldon@bigbangtheory.com"}, "body_plain" => "hello", "attachments" => {}}
    end

    it do
      message = TestMailer.simple_message_with_nice_from
      message.deliver!
    end
  end

  context 'when delivering a multipart message' do
    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com',
        'subject' => 'Your invitation to join Mixlr.', 'body' => "<b>hello</b>\n", "body_plain" => "hello\n", 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => {} }
    end

    it do
      message = TestMailer.multipart_message
      message.deliver!
    end
  end

  context 'when delivering a single part message' do
    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com',
        'subject' => 'Your invitation to join Mixlr.', "body_plain" => "hello\n", 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => {} }
    end

    it do
      message = TestMailer.singlepart_message
      message.deliver!
    end
  end

  context 'when delivering a message with attachments' do
    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com',
        'subject' => 'Message with attachment.', 'body' => 'attachments?', 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => { 'empty.gif' => 'R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==' } }
    end

    it do
      message = TestMailer.message_with_attachment
      message.deliver!
    end
  end

  context 'when delivering a message with inline image' do
    let(:message) { TestMailer.message_with_inline_image }

    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com',
        'subject' => 'Message with inline image.', 'body' => message.html_part.body.to_s, 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => { 'empty.gif' => 'R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==' } }
    end

    it do
      message.deliver!
    end
  end

  context 'when delivering a message with templated message' do
    let(:message) { TestMailer.message_with_template }

    let(:expected_body) do
      { 'to' => 'sheldon@bigbangtheory.com', 'from' => 'leonard@bigbangtheory.com', 'message_data' => { 'foo' => 'bar' },
        'subject' => 'Message with template.', 'transactional_message_id' => '123', 'headers' => {}, 'identifiers' => { 'email' => 'sheldon@bigbangtheory.com' }, 'attachments' => {} }
    end

    it do
      message.deliver!
    end
  end
end
