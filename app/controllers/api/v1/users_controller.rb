module API
  module V1

    class UsersController < API::V1::ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authorize_auth_token, only: :create
      before_action :set_user, only: [:show, :update]

      def index
        @users = User.all.order(:last_name)
      end

      def show
      end

      def create
        @user = User.new(user_params)
        if @user.save
          @user.reload
          @device = @user.devices.create(remote_ip: request.remote_ip, user_agent: request.user_agent, last_sign_in_at: Time.now)
        end
      end

      def update
        if @user.update_attributes(user_params)
        else
        end
      end

      private

        def set_user
          @user = User.find_by(public_id: params[:id])
        end

        def user_params
          params.required(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
        end
    end
  end
end
