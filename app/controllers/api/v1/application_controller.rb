class API::V1::ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :verify_api_token
# before_action :authorize_auth_token

  private

    def verify_api_token
      authorize_api_token || render_api_unauthorized
    end

    def authorize_api_token
      authenticate_or_request_with_http_token do |token, options|
        CapsuleApp::Application.config.api_secret_key_base == api_token(token)
      end
    end

    def render_api_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: 'Bad API Key', status: 401
    end

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

    def api_token(token)
      split_token(token)[1]
    end

    def authentication_token(token)
      split_token(token)[2]
    end

    def split_token(token)
      token.split(/^([^:]+):*(.*)/)
    end
end
