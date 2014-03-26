class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to @user, notice: 'User has been created'
    else
      render action: 'new'
    end
  end

  def update
    if @user.update_attributes user_params
      redirect_to @user, 'User was updated'
    else
      render action: 'edit'
    end
  end

  private

    def set_user
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
end
