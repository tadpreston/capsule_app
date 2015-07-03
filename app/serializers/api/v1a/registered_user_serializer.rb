module API
  module V1a
    class RegisteredUserSerializer < ActiveModel::Serializer
      attributes *RegisteredUser::ATTRIBUTES

      def profile_image
        object.signed_profile_image
      end
    end
  end
end
