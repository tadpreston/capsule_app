class RecipientWorker
  include Sidekiq::Worker

  def perform(user_id, capsule_id)
    RecipientMailer.capsule_notification(user_id, capsule_id).deliver
  end
end
