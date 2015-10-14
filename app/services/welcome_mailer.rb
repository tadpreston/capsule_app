class WelcomeMailerRejectedError < StandardError; end
class WelcomeMailer
  attr_reader :email, :subject, :from_name, :template_name

  def initialize email, subject, from_name, template_name
    @email = email
    @subject = subject
    @from_name = from_name
    @template_name = template_name
  end

  def self.deliver email:, subject:, from_name:, template_name: ENV['DEFAULT_MANDRILL_TEMPLATE']
    new(email, subject, from_name, template_name).deliver
  end

  def deliver
    result = mandrill.messages.send message
    raise WelcomeMailerRejectedError, error_message(result.first)  unless result.first['status'] == 'sent'
    result
  end

  private

  def message
    {
      subject: subject,
      from_name: from_name,
      from_email: ENV['DEFAULT_FROM_EMAIL'],
      to: [ { email: email } ],
      html: template.fetch("html")
    }
  end

  def mandrill
    @mandrill ||= Mandrill::API.new
  end

  def template options=[]
    mandrill.templates.render template_name, options
  end

  def error_message result
    "#{result['status']} - #{result['reject_reason']}"
  end
end
