module API
  module V1

    class SessionsController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token

      def create
        auth = Authentication.new(params, request)
        if @user = auth.authenticated?
        else
          invalid_login_attempt
        end
      end

      def destroy
        if @device = Device.find_by(auth_token: params[:id])
          @device.expire_auth_token!
          render json: { status: 'Successfully logged out' }
        else
          render json: { status: 'Not Found', response: { errors: [ { session: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
        end
      end

      private

        def invalid_login_attempt
          render json: { status: 'Invalid email or password' }, status: 401
        end

    end
  end
end
