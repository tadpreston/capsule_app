class RecipientMailer < ActionMailer::Base
  default from: "yada@pinyada.com"

  def capsule_notification(user_id, capsule_id)
    get_user_and_capsule user_id, capsule_id
    mail(to: @user.email, subject: "You have been sent a Yada.", content_type: "text/html")
  end

  def unlocked_capsule(user_id, capsule_id)
    get_user_and_capsule user_id, capsule_id
#   mail(to: @user.email, subject: "A Yada has been unlocked and is ready to you to view!", content_type: "text/html")
    mail(to: 'tadpreston@gmail.com', subject: "A Yada has been unlocked and is ready to you to view!", content_type: "text/html")
  end

  private

  def get_user_and_capsule user_id, capsule_id
    @user = User.find user_id
    @capsule = Capsule.find capsule_id
  end
end
