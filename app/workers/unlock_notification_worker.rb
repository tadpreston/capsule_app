class UnlockNotificationWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :time_yada

  def perform capsule_id
    capsule = Capsule.find capsule_id
    Notifications::UnlockNotification.new(capsule).process
  end
end
