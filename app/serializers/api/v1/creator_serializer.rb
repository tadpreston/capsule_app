module API
  module V1
    class CreatorSerializer < ActiveModel::Serializer
      cached
      delegate :cache_key, to: :object

      attributes :id, :full_name, :profile_image
    end
  end
end
