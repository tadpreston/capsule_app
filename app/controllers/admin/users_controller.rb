module Admin
  class UsersController < Admin::ApplicationController
    before_action :set_user, only: [:edit, :update, :show, :destroy]

    def index
      if params[:query].blank?
        @users = User.all.order(:last_name).page(params[:page]).per(13)
      else
        q = "%#{params[:query]}%"
        @users = User.where('first_name ilike ? OR last_name ilike ? OR email ilike ?', q, q, q).order(:last_name).page(params[:page]).per(13)
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
        params.required(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end

  end
end