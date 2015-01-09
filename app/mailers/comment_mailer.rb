class CommentMailer < ActionMailer::Base
  default from: "hello@pinyadaapp.com"

  def new_comment user_id, capsule_id, message
    @user = User.find user_id
    @capsule = Capsule.unscoped.find capsule_id
    mail(to: @user.email, subject: message, content_type: "text/html")
  end
end
