module Admin
  class AdminUsersController < Admin::ApplicationController
    before_action :set_admin_user, only: [:edit, :update, :show, :destroy]

    def index
      @admin_users = AdminUser.all.order(:last_name)
    end

    def new
      @admin_user = AdminUser.new
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)
      if @admin_user.save
        redirect_to admin_admin_users_path, notice: 'Admin User Successfully Created'
      else
        flash.now[:alert] = 'Errors occurred while creating the user'
        render action: :new
      end
    end

    def edit
    end

    def update
      if @admin_user.update_attributes(admin_user_params)
        redirect_to admin_admin_users_path, notice: 'Admin user successfully updated'
      else
        flash.now[:alert] = 'Errors occurred while updating the user'
        render action: :edit
      end
    end

    def show
    end

    def destroy
      @admin_user.destroy
      redirect_to admin_admin_users_path, notice: 'Admin user successfully destroyed'
    end

    private

      def set_admin_user
        @admin_user = AdminUser.find params[:id]
      end

      def admin_user_params
        params.required(:admin_user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
      end

  end
end
