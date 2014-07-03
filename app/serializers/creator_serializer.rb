class CreatorSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  attributes :id, :first_name, :last_name, :profile_image
end
