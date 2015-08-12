module API
  module V1a
    class SessionsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def create
        auth = Authentication.new(params, request)
        if @user = auth.authenticated?
          render json: SessionSerializer.new(@user, root: false)
        else
          invalid_login_attempt
        end
      end

      def create_with_facebook
        validator = FacebookValidator.new params[:facebook_id], params[:facebook_token]
        r = { fbid: params[:facebook_id], t: params[:facebook_token], valid: validator.validates }

         render json: r
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
