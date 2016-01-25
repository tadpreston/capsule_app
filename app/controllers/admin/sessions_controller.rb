module Admin
  class SessionsController < Admin::ApplicationController
    skip_before_action :authorize

    def create
      if user = AdminUser.find_by(email: params[:email]).try(:authenticate, params[:password])
        session[:user_id] = user.id
        redirect_to admin_root_url, notice: "Logged In"
      else
        flash.now[:alert] = "Email or password is invalid"
        render action: :new
      end
    end
  end
end
