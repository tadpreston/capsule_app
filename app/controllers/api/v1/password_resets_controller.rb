module API
  module V1
    class PasswordResetsController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token

      def create
        user = User.find_by email: params[:email]
        user.send_password_reset if user
        render json: { notice: "Email sent with password reset instructions." }
      end
    end
  end
end
