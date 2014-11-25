class CapsuleWorker
  include Sidekiq::Worker

  def perform(capsule_id)
    NotificationWorker.perform_async(capsule_id)
    A3Worker.perform_in(10.seconds, capsule_id)
  end
end
