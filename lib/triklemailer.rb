require 'mail'
require 'csv'

module Triklemailer
  VERSION = '0.0.6'
  Options = Struct.new(:template, :template_name, :is_html, :from, :subject, keyword_init: true)

  # It should take:
  # * A list of emails and data
  # * SMTP account details
  # * A template
  # * SMTP Server details
  # 
  # and it should send an email to each email address from the csv using
  # the template provided, filled in with the meta data provided for the
  # email address. When each email is sent it should record that in a
  # separate csv called sent_<template-name>.csv. Failures to send a
  # messages should not be recorded. When sending emails it should check
  # the sent_<template-name>.csv and if it exists, only send emails to 
  # email address not included in the sent_<template-name>.csv file.
  #
  # Read provided csv
  # Check for sent_ csv
  # For each email, meta_data in provided csv
  #   If email in sent_ csv
  #     Next email
  #
  #   Read template file
  #   Apply meta_data to template file
  #   Send email with data from cli or meta data with template
  #   If there was an error sending
  #     Next email
  #   Record email sent to template in sent_ csv
  #
  def self.send_mail(options, recipients, sent)
    cleaned_template = options.template.gsub(/%(?!{)/, '%%')

    recipients.
      reject { |recipient| sent.include?(recipient[:email]) }.
      each do |recipient|
      mail = Mail.new do
        from recipient.fetch(:from, options.from)
        to recipient.fetch(:to, recipient.fetch(:email) {
          raise "Some rows are missing either a 'to' or 'email' column."
        })
        subject recipient.fetch(:subject, options.subject)

        if options.is_html
          html_part do
            content_type 'text/html; charset=UTF-8'
            body cleaned_template % recipient
          end
        else
          text_part do
            body cleaned_template % recipient
          end
        end
      end

      if block_given?
        yield(mail, recipient)
      else
        mail.delivery_method :smtp, {
          address: recipient.fetch(:host, options.host),
          port: recipient.fetch(:port, options.port),
          user_name: recipient.fetch(:username, options.username),
          password: recipient.fetch(:password, options.password),
          authentication: :login,
          enable_starttls_auto: true
        }
      end

      begin
        mail.deliver!
        # might fail in here though...
        log_sent(
          recipient.fetch(:to, recipient[:email]),
          options.template_name)
      rescue => e
        puts "Failed to send email to #{recipient[:email]}."
        next
      end
    end
  end

  def log_sent(email, template)
    log_file_name = ['sent', template.split('.').first].join('_')

    CSV.open(
      "./#{log_file_name}.csv",
      'a',
      write_headers: true,
      headers: ['email', 'sent_at']
    ) do |csv|
      csv << [email, Time.now]
    end
  end
end
