class CapsuleCommentNotificationWorker
  include Sidekiq::Worker

  def perform(capsule_id, commenter_id)
    Notifications::CommentNotification.new(capsule_id, commenter_id).process
  end
end
