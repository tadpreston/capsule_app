class CapsuleSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :in_reply_to, :comment, :location, :relative_location, :payload_type, :status, :promotional_state
  attributes :id, :in_reply_to, :recipients, :location, :relative_location, :payload_type, :status, :promotional_state
  attributes :thumbnail_path, :start_date, :lock_question, :lock_answer
  attributes :likes_count, :comments_count, :created_at, :updated_at, :comments, :assets

  def comments
    object.comments.map do |comment|
      CommentSerializer.new comment, root: false
    end
  end

  def assets
    object.assets.map do |asset|
      AssetSerializer.new asset, root: false
    end
  end
end
