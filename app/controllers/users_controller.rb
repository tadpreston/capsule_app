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
    set_user
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

    def set_new_user
      @user = User.new user_params
      if FacebookValidator.validate @params[:facebook_id], @params[:facebook_token]
        @user.password, @user.password_confirmation = 'some_string', 'some_string'
      end
    end

    def user_params
      params.require(:user).permit(:email, :full_name, :password, :password_confirmation, :facebook_id)
    end
end
