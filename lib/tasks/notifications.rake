namespace :notifications do
  desc 'Generate unlocked notifications'
  task :generate => :environment do
    NotificationWorker.perform_async Time.now.utc
  end
end
