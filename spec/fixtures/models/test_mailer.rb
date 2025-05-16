class TestMailer < ActionMailer::Base
  default subject: 'hello',
          to: 'sheldon@bigbangtheory.com',
          from: 'leonard@bigbangtheory.com'

  def simple_message
    mail
  end

  def simple_message_with_nice_from
    mail(from: 'Leonard Hofstadter <leonard@bigbangtheory.com>', body: 'hello')
  end

  def multipart_message
    mail(subject: "Your invitation to join Mixlr.") do |format|
      format.text
      format.html
    end
  end

  def singlepart_message
    mail(subject: "Your invitation to join Mixlr.")
  end

  def message_with_attachment
    attachments['empty.gif'] = File.read(image_file)
    mail(subject: "Message with attachment.")
  end

  def message_with_inline_image
    attachments.inline['empty.gif'] = File.read(image_file)
    mail(subject: "Message with inline image.")
  end

  def message_with_metadata
    metadata['foo'] = 'bar'
    mail(subject: 'Message with metadata.')
  end

  def message_with_template
    mail(subject: 'Message with template.', transactional_message_id: '123', message_data: { foo: 'bar' })
  end

  protected

  def image_file
    File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'empty.gif')
  end

end