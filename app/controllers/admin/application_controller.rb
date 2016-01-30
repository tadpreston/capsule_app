class Admin::ApplicationController < ActionController::Base
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authorize

  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: 'Resource Not Found' }, status: 404
  end

  %i{index show new create edit update destroy}.each do |method|
    define_method method do
      render json: { error: 'Method Not Allowed' }, status: 405
    end
  end

  private

  def current_user
    @current_user ||= AdminUser.find_by(auth_token: auth_token) if auth_token
  end
  helper_method :current_user

  def authorize
    render json: { status: 'Not authorized' }, status: 401 unless current_user
  end

  def auth_token
    request.headers['HTTP_PINYADA_ADMIN_AUTH_TOKEN']
  end
end
