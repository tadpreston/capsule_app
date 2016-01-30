module API
  module V1a
    class ClientsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token
      before_action :find_client, only: [:show, :update, :destroy]

      rescue_from ActiveRecord::RecordNotFound do
        render json: resource_not_found_response(:category, params[:id]), status: 404
      end

      def index
        render json: Client.all, each_serializer: API::V1a::ClientSerializer
      end

      def show
        render json: @client, serializer: API::V1a::ClientSerializer
      end

      def create
        @client = Client.new client_params.merge(created_by: current_user.id, updated_by: current_user.id)
        if @client.save
          render json: @client, serializer: API::V1a::ClientSerializer
        else
          render_client_errors
        end
      end

      def update
        if @client.update_attributes(client_params.merge(updated_by: current_user.id))
          render json: @client, serializer: API::V1a::ClientSerializer
        else
          render_client_errors
        end
      end

      def destroy
        @client.destroy
        render json: { status: 'Deleted' }
      end

      private

      def find_client
        @client = Client.find params[:id]
      end

      def client_params
        params.required(:client).permit(:user_id, :name)
      end

      def render_client_errors
        render status: 422, json: {
          errors: [
            status: '422',
            code: '422',
            title: @client.errors,
            links: [],
            path: request.env['REQUEST_PATH']
          ]
        }
      end
    end
  end
end

