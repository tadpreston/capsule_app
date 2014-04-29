class UserMailer < ActionMailer::Base
  default from: "confirm@capsuleapp.net"

  def email_confirmation(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Capsule! Please confirm your email address.", content_type: "text/html")
  end
end
