module API
  module V1

    class UsersController < API::V1::ApplicationController
      before_action :set_user, only: [:show, :update, :following, :followers]
      skip_before_action :authorize_auth_token, only: [:index, :show, :create, :following, :followers, :recipient, :registered]

      def index
        @users = User.all.order(:last_name)
      end

      def show
      end

      def create
        @user = User.new(user_params.merge(provider: 'capsule'))
        if @user.save
          @user.reload
          @device = @user.devices.create(remote_ip: request.remote_ip, user_agent: request.user_agent, last_sign_in_at: Time.now)
        else
          render :create, status: 422
        end
      end

      def update
        if current_user.id == @user.id
          original_email = @user.email
          unless @user.update_attributes(user_params)
            render :update, status: 422
          else
            if user_params[:email]
              @user.send_confirmation_email
              @user.update_columns(unconfirmed_email: user_params[:email], email: original_email)
            end
          end
        else
          render json: { status: 'Not Authorized', response: { errors: [ { user: [ "Not authorized to update id: #{params[:id]}" ] } ] } }, status: 401
        end
      end

      def follow
        @follow_user = User.find(params[:user][:follow_id])
        current_user.follow!(@follow_user)
      end

      def unfollow
        @follow_user = User.find(params[:id])
        current_user.unfollow!(@follow_user)
        render json: { status: 'Success' }
      end

      def remove_follower
        user = User.find(params[:id])
        current_user.remove_follower!(user)
        render json: { status: 'Success' }
      end

      def following
        @users = @user.followed_users
      end

      def followers
        @users = @user.followers
      end

      def recipient
        @user = User.find_by(recipient_token: params[:id])
        @user.update_attributes(user_params.merge(recipient_token: nil))
        @user.send_confirmation_email
      end

      def registered
        @registered_users = RegisteredUser.find params[:q]
        render json: @registered_users, each_serializer: RegisteredUserSerializer
      end

      private

      def set_user
        begin
          @user = User.find(params[:id])
        rescue
          render json: { status: 'Not Found', response: { errors: [ { user: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
        end
      end

      def user_params
        params.required(:user).permit(:email, :username, :first_name, :last_name, :location, :password, :password_confirmation, :time_zone, :tutorial_progress, :phone_number,
                                      :motto, :background_image, :facebook_username, :twitter_username, :profile_image, :device_token,
                                      oauth: [
                                        { location: [:id, :name] }, { friends: [:name, :id, :username, :first_name, :last_name] }, :birthday, :quotes, :verified, :work, :education,
                                        :timezone, :updated_time, :name, :email, :birthdate, :locale, :first_name, :username, :id, :provider, :uid,
                                        :gender, :last_name, { hometown: [:id, :name] }, :link
                                      ]
                                     )

      end
    end
  end
end
