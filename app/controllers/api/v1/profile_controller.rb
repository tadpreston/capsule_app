module API
  module V1

    class ProfileController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token
      before_action :set_user

      def index
        @capsules = @user.json_capsules
        @watched_capsules = @user.cached_watched_capsules
        @watched_locations = @user.cached_location_watches
        @following = @user.cached_followed_users
        @followers = @user.cached_followers
      end

      def byme
        @capsules = @user.cached_capsules
      end

      def watched
        @watched_capsules = @user.cached_watched_capsules
        @watched_locations = @user.cached_location_watches
        @following = @user.cached_followed_users
      end

      def followers
        @followers = @user.cached_followers
      end

      def loadtest
#       @capsules = @user.cached_capsules
#       @capsules = Capsule.where(user_id: @user.id)
        @capsules = Capsule.all.limit(1000)
      end

      private

        def set_user
          if params[:id]
            begin
              @user = User.find(params[:id])
            rescue
              render json: { status: 'Not Found', response: { errors: [ { user: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
            end
          elsif current_user
            @user = current_user
          else
            render json: { status: 'Not Found', response: { errors: [ { user: [ "No user id provided" ] } ] } }, status: 404
          end
        end
    end
  end
end
