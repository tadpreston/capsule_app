class API::V1::ApplicationController < ActionController::Base
  before_action :authorize_auth_token

  private

    def current_user
      @current_user ||= current_device.user if current_device
    end
    helper_method :current_device

    def current_device
      @current_device ||= Device.find_by(auth_token: params[:auth_token]) if params[:auth_token]
    end

    def authorize_auth_token
      head :unauthorized unless current_device
    end
end
