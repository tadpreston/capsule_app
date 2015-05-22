class PasswordResetController < ApplicationController
  def index
		@token = params[:token]
	end
end
