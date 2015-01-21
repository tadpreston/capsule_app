class CreatorSerializer < ActiveModel::Serializer
# cached
# delegate :cache_key, to: :object

  attributes :id, :full_name, :phone_number, :email, :location, :profile_image_path, :created_at, :updated_at
end
