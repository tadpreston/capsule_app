module API
  module V1a
    class CategoriesController < API::V1a::ApplicationController
      rescue_from ActiveRecord::RecordNotFound do
        render json: resource_not_found_response(:category, params[:id]), status: 404
      end

      def index
        render json: Category.all, each_serializer: CategorySerializer
      end

      def show
        category = Category.find params[:id]
        render json: category, serializer: CategorySerializer
      end
    end
  end
end
