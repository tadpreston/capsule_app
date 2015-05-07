module API
  module V1a
    class CommentUserSerializer < ActiveModel::Serializer
    # cached
    # delegate :cache_key, to: :object

      attributes :id, :email, :full_name, :phone_number, :profile_image

      def profile_image
        object.signed_profile_image_path
      end
    end
  end
end
