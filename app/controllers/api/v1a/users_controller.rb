module API
  module V1a
    class UsersController < API::V1a::ApplicationController
      before_action :set_user, only: [:show, :update, :following, :followers, :password]
      before_action :verify_update, only: [:update, :password]
      skip_before_action :authorize_auth_token, only: [:index, :show, :create, :following, :followers, :recipient, :registered, :password]

      def index
        @users = User.all.order(:last_name)
      end

      def show
      end

      def create
        user = UserForm.create_user user_params
        Device.create({ remote_ip: request.remote_ip, user_agent: request.user_agent, last_sign_in_at: Time.now, user_id: user.id })
        render json: SessionSerializer.new(user, root: false)
      rescue ValidationError
        render :create, status: 422
      end

      def update
        if @user.update_attributes(user_params)
          render json: @user, serializer: UserSerializer
        else
          render json: user_not_updated(@user.errors, @user.id)
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

      def password
        @user.change_password user_params
      rescue User::PasswordChangeError => e
        render json: password_not_changed(e.message, @user.id), status: 403
      else
        render json: SessionSerializer.new(@user, root: false)
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
        params.required(:user).permit(:email, :username, :full_name, :location, :password, :password_confirmation, :time_zone, :tutorial_progress, :phone_number,
                                      :motto, :background_image, :facebook_username, :twitter_username, :profile_image, :device_token, :old_password,
                                      oauth: [
                                        { location: [:id, :name] }, { friends: [:name, :id, :username, :full_name] }, :birthday, :quotes, :verified, :work, :education,
                                        :timezone, :updated_time, :name, :email, :birthdate, :locale, :full_name, :id, :provider, :uid,
                                        :gender, :last_name, { hometown: [:id, :name] }, :link
                                      ]
                                     )

      end

      def verify_update
        unless current_user.id == @user.id
          render json: { status: 'Not Authorized', response: { errors: [ { user: [ "Not authorized to update id: #{params[:id]}" ] } ] } }, status: 401
        end
      end

      def password_not_changed message, id
        {
          errors: [{
            status: '403',
            code: '403',
            title: 'Password Not Changed',
            detail: message,
            links: id
          }]
        }
      end

      def user_not_updated message, id
        {
          errors: [{
            status: '403',
            code: '403',
            title: 'User not updated',
            detail: message,
            links: id
          }]
        }
      end
    end
  end
end
