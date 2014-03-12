module Api
  module V1

    class SessionsController < ::ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        @user = User.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
          @device = @user.devices.current_device(request.remote_ip, request.user_agent)
          if @device
            @device.last_sign_in_at = Time.now
            @device.reset_auth_token!
          else
            @device = @user.devices.create(remote_ip: request.remote_ip, user_agent: request.user_agent, last_sign_in_at: Time.now)
          end
        else
          invalid_login_attempt
        end
      end

      def destroy
        if @device = Device.find_by(auth_token: params[:id])
          @device.expire_auth_token!
          render :json => { message: "Successfully logged out" }
        else
          render :json => { message: 'Session not found' }, status: 404
        end
      end

      private

        def invalid_login_attempt
          render :json => { message: "Invalid email or password" }, status: 401
        end
    end
  end
end
