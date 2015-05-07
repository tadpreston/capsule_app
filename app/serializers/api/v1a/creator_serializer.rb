module API
  module V1a
    class CreatorSerializer < ActiveModel::Serializer
      attributes :id, :full_name, :phone_number, :email, :location, :profile_image, :created_at, :updated_at

      def profile_image
        object.signed_profile_image_path
      end
    end
  end
end
