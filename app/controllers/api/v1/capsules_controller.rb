module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update]

      def index
        @capsules = current_user.capsules.by_updated_at
      end

      def watched
        @capsules = current_user.favorite_capsules.by_updated_at
      end

      def show
      end

      def create
        @capsule = Capsule.new(capsule_params)
        unless @capsule.save
          render :create, status: 422
        end
      end

      def update
        unless @capsule.update_attributes(capsule_params)
          render :update, status: 422
        end
      end

      private

        def set_capsule
          begin
            @capsule = Capsule.find params[:id]
          rescue
            render json: { status: 'Not Found', response: { errors: [ { capsule: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
          end
        end

        def capsule_params
          params.required(:capsule).permit(:user_id, :title, :location, :status, :payload_type, :promotional_state, :passcode, :visibility)
        end
    end
  end
end
