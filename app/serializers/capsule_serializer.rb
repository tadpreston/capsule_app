class CapsuleSerializer < ActiveModel::Serializer
#  cached
#  delegate :cache_key, to: :object
  delegate :current_user, to: :scope

  attributes :id, :comment, :creator, :recipients, :location, :relative_location, :payload_type, :status, :promotional_state
  attributes :thumbnail_path, :assets, :start_date, :lock_question, :lock_answer
  attributes :likes_count, :comments_count, :is_read, :is_unlocked, :created_at, :updated_at

  def assets
    object.assets.map do |asset|
      AssetSerializer.new asset, root: false
    end
  end

  def creator
    CreatorSerializer.new object.user, root: false if object.user
  end

  def recipients
    object.recipients.map do |recipient|
      RecipientSerializer.new recipient, root: false
    end
  end

  def is_read
    object.read_by? current_user
  end

  def is_unlocked
    object.is_unlocked? current_user
  end
end
