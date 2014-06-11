class RecipientMailer < ActionMailer::Base
  default from: "capsule@capsulethemoment.com"

  def capsule_notification(user_id, capsule_id)
    @user = User.find user_id
    @capsule = Capsule.find capsule_id
#   mail(to: user.email, subject: "Welcome to Capsule! You have been sent a capsule.", content_type: "text/html")
  end
end
