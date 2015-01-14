namespace :notifications do
  desc 'Generate unlocked notifications'
  task :generate => :environment do
    NotificationWorker.perform_async Time.now.utc
    Capsule.all.each do |capsule|
      UnlockNotificationWorker.perform_at(capsule.start_date, capsule.id) if capsule.start_date
    end
  end
end
