class YadaMailer < ActionMailer::Base
  default from: "yada@pinyada.com"

  def yada_read capsule_id, user_id
    @capsule = Capsule.unscoped.find capsule_id
    @author = @capsule.user
    @user = User.find user_id
    mail(to: @author.email, subject: "Your Yada has been read by #{@user.full_name}")
  end
end
