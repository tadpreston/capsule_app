class UserMailer < ActionMailer::Base
  default from: "hello@pinyadaapp.com"

  def email_confirmation(user)
    @user = user
    mail(to: user.email, subject: "Welcome to PinYada! Please confirm your email address.", content_type: "text/html")
  end
end
