require 'triklemailer'

Mail.defaults do
  delivery_method :test
end

describe Triklemailer do
  include Mail::Matchers

  before(:each) do
    Mail::TestMailer.deliveries.clear
  end

  describe '#send_mail(options, recipients, sent)' do
    it 'should send an email' do
      options = Triklemailer::Options.new(
        template: '',
        from: 'test@test.com',
        subject: 'test'
      )
      recipients = [{
        email: 'test@test.com',
      }]
      sent = []

      Triklemailer.send_mail(options, recipients, sent) do |mail, recipient|
        mail.delivery_method :test
      end

      is_expected.to have_sent_email.from('test@test.com')
      is_expected.to have_sent_email.to('test@test.com')
    end

    it 'should not send an email' do
      options = Triklemailer::Options.new(
        template: '',
        from: 'test@test.com',
        subject: 'test'
      )
      recipients = [{
        email: 'test@test.com',
      }]
      sent = ['test@test.com']

      Triklemailer.send_mail(options, recipients, sent) do |mail, recipient|
        mail.delivery_method :test
      end

      is_expected.to_not have_sent_email
    end
  end
end
