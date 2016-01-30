class Admin::ClientsController < Admin::ApplicationController
  def index
    clients = Client.all
    render json: clients, each_serializer: Admin::ClientSerializer
  end

  def show
    client = Client.find params[:id]
    render json: client, serializer: Admin::ClientSerializer
  end
end
