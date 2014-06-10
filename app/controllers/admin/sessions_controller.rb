module Admin
  class SessionsController < Admin::ApplicationController
    skip_before_action :authorize

    def new
    end

    def create
      user = AdminUser.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to admin_root_url, notice: "Logged In"
      else
        flash.now[:alert] = "Email or password is invalid"
        render action: :new
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to new_admin_session_path
    end
  end
end
