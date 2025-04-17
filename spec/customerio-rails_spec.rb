# frozen_string_literal: true

require 'spec_helper'

describe "CustomerioRails" do
  let!(:api_client) { Customerio::APIClient.new('app-api-token') }

  def deliver(message)
    if message.respond_to?(:deliver_now)
      message.deliver_now
    else
      message.deliver
    end
  end

  before do
    allow(Customerio::APIClient).to receive(:new) { api_client }
  end

  it 'should allow setting an app api key' do
    ActionMailer::Base.customerio_settings = {:app_api_key => 'app-api-token'}
    expect(ActionMailer::Base.customerio_settings[:app_api_key]).to eq('app-api-token')
  end

  it "should use customerio for delivery" do
    allow(api_client).to receive(:send_email) do |message|
      expect(message.message[:subject]).to eq("hello")
    end
    deliver(TestMailer.simple_message)
  end

  it "should work with multipart messages" do
    allow(api_client).to receive(:send_email) do |message|
      expect(message.message[:body].strip).to eq("<b>hello</b>")
      expect(message.message[:body_plain].strip).to eq("hello")
    end
    deliver(TestMailer.multipart_message)
  end

  it 'should work with messages containing attachments' do
    allow(api_client).to receive(:send_email) do |message|
      expect(message.message[:attachments]).not_to be_empty
    end
    deliver(TestMailer.message_with_attachment)
  end
end
