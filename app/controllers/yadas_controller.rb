class YadasController < ApplicationController
  before_action :set_yada
  rescue_from 'RecordNotFound', with: :render_resource_not_found

  def show
    render json: @yada
  end

  private

  def set_yada
    @yada = Capsule.find_by token: params[:id]
    render json: token_expired_response(params[:id]) if @yada.token_created_at.utc < 7.days.ago.utc
  end

  def render_resource_not_found
    render json: resource_not_found_response(params[:id])
  end

  def resource_not_found_response token
    {
      errors: [{
        status: '404',
        code: '404',
        title: 'Not Found',
        detail: 'Resource not found',
        links: Hash[resource.to_sym, [token]]
      }]
    }
  end

  def token_expired_response token
    {
      errors: [{
        status: '404',
        code: '404',
        title: 'Token expired',
        detail: 'Token expired',
        links: Hash[resource.to_sym, [token]]
      }]
    }
  end

  def resource
    params[:controller].split('/').last.to_s.singularize
  end
end
