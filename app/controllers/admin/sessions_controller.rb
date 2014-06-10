module Admin
  class SessionsController < Admin::ApplicationController
    def new
    end

    def create
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to admin_root_url, notice: "Logged In"
      else
        flash.now[:alert] = "Email or password is invalid"
        render action: :new
      end
    end

    def destroy
    end
  end
end
