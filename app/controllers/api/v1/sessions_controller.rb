module API
  module V1

    class SessionsController < API::V1::ApplicationController

      def create
        @user = get_user
        if @user && @user.authenticate(params[:password])
          @user.reload
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
          render :json => { status: 'Successfully logged out' }
        else
          render :json => { status: 'Session not found' }, status: 404
        end
     end

      private

        def invalid_login_attempt
          render :json => { message: "Invalid email or password" }, status: 401
        end

        def get_user
          if params[:email]
            User.find_by(email: params[:email])
          elsif params[:oauth]
            User.find_or_create_by_oauth(params[:oauth])
          end
        end

    end
  end
end
