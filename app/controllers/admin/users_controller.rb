module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, only: [:edit, :update, :show, :destroy]

    def index
      if params[:q].blank?
        @users = User.all.order(:last_name).limit(100)
      else
        q = "%#{params[:q]}%"
        @users = User.where('full_name ilike ? OR email ilike ?', q, q).order(:email)
      end
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'Admin User Successfully Created'
      else
        flash.now[:alert] = 'Errors occurred while creating the user'
        render action: :new
      end
    end

    def edit
    end

    def update
      if @user.update_attributes(user_params)
        redirect_to admin_users_path, notice: 'Admin user successfully updated'
      else
        flash.now[:alert] = 'Errors occurred while updating the user'
        render action: :edit
      end
    end

    def show
    end

    def destroy
      @user.destroy
      redirect_to admin_users_path, notice: 'Admin user successfully destroyed'
    end

    private

      def set_user
        @user = User.find params[:id]
      end

      def user_params
        params.required(:user).permit(:email, :full_name, :password, :password_confirmation)
      end

  end
end
