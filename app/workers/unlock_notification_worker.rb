class UnlockNotificationWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :time_yada

  def perform capsule_id
    capsule = Capsule.find capsule_id
    unlock_yada capsule
    Notifications::UnlockNotification.new(capsule).process
  end

  def unlock_yada capsule
    capsule.recipients.each { |recipient| capsule.unlock recipient }
  end
end
