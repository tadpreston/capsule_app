module API
  module V1

    class ProfileController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token
      before_action :set_user

      def index
        @capsules = @user.my_capsules
        @watched_capsules = @user.watched_capsules
        @watched_locations = @user.location_watches
        @following = @user.followed_users
        @followers = @user.followers
      end

      def loadtest
#       @capsules = @user.cached_capsules
#       @capsules = Capsule.where(user_id: @user.id)
        @capsules = Capsule.all.limit(1000)
      end

      def loadtest_jbuilder
        @capsules = Capsule.all.limit(2750).includes(:user, :watchers, :read_by)
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
