class NotificationWorker
  include Sidekiq::Worker

  def perform time
    capsule_ids = Capsule.unscoped.where('start_date < ?', time).ids
    capsule_ids.each do |id|
      UnlockNotificationWorker.perform_async id
    end
  end
end
