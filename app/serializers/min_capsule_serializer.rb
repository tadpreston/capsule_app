class MinCapsuleSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :title, :hash_tags, :location, :relative_location, :thumbnail
  attributes :incognito, :is_portable, :is_processed, :comments_count, :creator

  def hash_tags
    object.hash_tags.split(' ')
  end

  def thumbnail
    object.thumbnail_path
  end

  def incognito
    object.incognito || false
  end

  def is_portable
    object.is_portable || false
  end

  def is_processed
    object.is_processed?
  end

  def creator
    { id: object.cached_user.id, first_name: object.cached_user.first_name, last_name: object.cached_user.last_name, profile_image: object.cached_user.profile_image }
  end
end
