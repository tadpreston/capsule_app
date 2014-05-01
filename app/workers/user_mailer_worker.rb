class UserMailerWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :mailer

  def perform(user_id, mailer)
    user = User.find user_id

    UserMailer.send(mailer, user).deliver
  end
end
