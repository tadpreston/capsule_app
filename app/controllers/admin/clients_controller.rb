class Admin::ClientsController < Admin::ApplicationController
  def index
    clients = Client.all
    render json: clients, each_serializer: Admin::ClientSerializer
  end

  def show
    client = Client.find params[:id]
    render json: client, serializer: Admin::ClientSerializer
  end

  def create
    @client = Client.new client_params.merge(created_by: current_user.id, updated_by: current_user.id)
    if @client.save
      render json: @client, serializer: API::V1a::ClientSerializer, status: 201
    else
      render_client_errors
    end
  end

  def update

  end

  private

  def client_params
    params.required(:client).permit :name, :email, :profile_image, :password, :password_confirmation
  end

  def render_client_errors
    render status: 400, json: {
      errors: [
        status: '400',
        code: '400',
        title: @client.errors,
        links: [],
        path: request.env['REQUEST_PATH']
      ]
    }
  end
end
