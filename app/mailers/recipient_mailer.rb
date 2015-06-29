class RecipientMailer < ActionMailer::Base
  default from: "hello@pinyadaapp.com"

  def capsule_notification(user_id, capsule_id)
    get_user_and_capsule user_id, capsule_id
    mail(to: @user.email, subject: "You have been sent a Yada.", content_type: "text/html")
  end

  def unlocked_capsule(user_id, capsule_id)
    get_user_and_capsule user_id, capsule_id
    mail(to: @user.email, subject: "A Yada has been unlocked and is ready for you to view!", content_type: "text/html")
  end

  def new_capsule user_id, capsule_id, message
    get_user_and_capsule user_id, capsule_id
    mail(to: @user.email, subject: message, content_type: "text/html")
  end

  private

  def get_user_and_capsule user_id, capsule_id
    @user = User.find user_id
    @capsule = Capsule.find capsule_id
  end
end
