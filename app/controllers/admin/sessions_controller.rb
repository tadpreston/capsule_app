module Admin
  class SessionsController < Admin::ApplicationController
    skip_before_action :authorize

    def create
      if user = AdminUser.authenticate_user(email: params[:session][:email], password: params[:session][:password])
        render json: { session: { auth_token: user.auth_token } }
      else
        render json: { status: 'Not Authenticated' }, status: 401
      end
    end
  end
end
