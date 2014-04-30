class ConfirmationsController < ApplicationController
  def email
    @user = User.find_by(confirmation_token: params[:conf_token])
    @user.email_confirmed! if @user
  end
end
