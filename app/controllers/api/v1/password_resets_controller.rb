module API
  module V1
    class PasswordResetsController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token
      before_action :set_user, only: [:edit, :update]

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
          if @user.update_attributes user_attributes
            render json: @user, serializer: UserSerializer
          else
            render json: bad_request_response(:password_resets, @user.errors.messages, @user.id), status: 400
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

      def bad_request_response resource, message, id=nil
        {
          errors: [{
            status: '400',
            code: '400',
            title: 'Bad Request',
            detail: (message || "Details not provided"),
            links: Hash[resource.to_sym, [id]]
          }]
        }
      end

      def resource_not_found_response resource, id
        {
          errors: [{
            status: '404',
            code: '404',
            title: 'Not Found',
            detail: 'Resource not found',
            links: Hash[resource.to_sym, [id]]
          }]
        }
      end
    end
  end
end
