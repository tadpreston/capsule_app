class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform user_id
    result = WelcomeMailer.deliver(email: user(user_id).email, subject: 'Welcome To PinYada!', from_name: 'PinYada').first
    MandrillResult.create user_id: user_id, status: result.status, message_id: result.message_id, reason: result.reject_reason
  end

  private

  def user user_id=nil
    @user ||= User.find user_id
  end
end
