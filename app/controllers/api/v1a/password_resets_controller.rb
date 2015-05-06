module API
  module V1a
    class PasswordResetsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token
      before_action :set_user, only: [:edit, :update]
      rescue_from('User::PasswordChangeError') { |exception| password_reset_error exception }

      def create
        user = User.find_by email: params[:email]
        user.send_password_reset if user
        render json: { notice: "Email sent with password reset instructions." }
      end

      def edit
        render json: @user, serializer: UserSerializer
      end

      def update
        if verify_password_token @user
          if @user.reset_password user_attributes
            render json: @user, serializer: UserSerializer
          end
        end
      end

      private

      def user_attributes
        params.required(:user).permit(:password, :password_confirmation)
      end

      def set_user
        @user = User.find_by_password_reset_token(params[:id])
        render json: resource_not_found_response(:password_resets, params[:id]), status: 404 unless @user
      end

      def verify_password_token user
        if user.password_reset_sent_at < 2.hours.ago
          render json: bad_request_response(:password_resets, 'Password token has expired', user.id), status: 404
          false
        else
          true
        end
      end

      def password_reset_error exception
        render json: bad_request_response(:password_resets, exception.message, @user.id), status: 400
      end
    end
  end
end
