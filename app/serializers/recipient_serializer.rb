class RecipientSerializer < ActiveModel::Serializer
# cached
  delegate :cache_key, to: :object

  attributes :id, :full_name, :phone_number, :email, :location, :profile_image, :created_at, :updated_at

  def profile_image
    object.profile_image_path
  end
end
