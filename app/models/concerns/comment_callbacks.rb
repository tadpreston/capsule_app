class CommentCallbacks
  def self.after_create comment
    CapsuleCommentNotificationWorker.perform_async comment.commentable_id, comment.user_id
  end
end
