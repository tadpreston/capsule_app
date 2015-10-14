class WelcomeEmailWorker
  include Sidekiq::Worker

  def perform user_id
    WelcomeMailer.deliver email: user(user_id).email, subject: 'Welcome To PinYada!', from_name: 'PinYada'
  end

  private

  def user user_id
    @user ||= User.find user_id
  end
end
