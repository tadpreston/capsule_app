class CommentCallbacks
  def self.after_create comment
    CapsuleCommentNotificationWorker.perform_async comment.commentable_id, comment.user_id
    FeedUpdater.new(comment.commentable_id, comment.user_id).perform
  end
end
