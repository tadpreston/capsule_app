class API::V1::ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :verify_api_token
  before_action :authorize_auth_token

  private

    def verify_api_token
      authorize_api_token || render_api_unauthorized
    end

    def authorize_api_token
      authenticate_with_http_token { |token, options| CapsuleApp::Application.config.api_secret_key_base == token }
    end

    def render_api_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: { status: 'Bad API Key' }, status: 401
    end

    def current_user
      @current_user ||= current_device.user if current_device
    end
    helper_method :current_user
    helper_method :current_device

    def current_device
      @current_device ||= Device.find_by(auth_token: request.headers['HTTP_CAPSULE_AUTH_TOKEN']) if request.headers['HTTP_CAPSULE_AUTH_TOKEN']
    end

    def authorize_auth_token
      render json: { status: 'Not authenticated' }, status: 403 unless current_device
    end
end
