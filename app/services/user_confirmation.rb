class UserConfirmation
  attr_accessor :user

  def initialize user
    @user = user
  end

  def send
    Token.generate_token user, :confirmation_token
    update_attributes(confirmation_sent_at: Time.now, confirmed_at: nil)
    UserMailerWorker.perform_async(self.id, :email_confirmation)
  end
end
