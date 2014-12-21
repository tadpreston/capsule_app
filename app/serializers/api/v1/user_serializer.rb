module API
  module V1
    class UserSerializer < ActiveModel::Serializer
      cached
      delegate :cache_key, to: :object

      attributes :id, :email, :username, :motto, :facebook_username, :twitter_username, :full_name
      attributes :phone_number, :location, :locale, :timezone, :provider, :uid, :profile_image, :background_image
      attributes :tutorial_progress, :settings, :email_confirmed, :watching_count, :watchers_count, :created_at, :updated_at

      def motto
        object.motto || ''
      end

      def facebook_username
        object.facebook_username || ''
      end

      def twitter_username
        object.twitter_username || ''
      end

      def phone_number
        object.phone_number || ''
      end

      def timezone
        object.time_zone || ''
      end

      def provider
        object.provider || ''
      end

      def uid
        object.uid || ''
      end

      def profile_image
        object.profile_image || ''
      end

      def background_image
        object.background_image || ''
      end

      def email_confirmed
        object.confirmed? ? true : false
      end

    end
  end
end
