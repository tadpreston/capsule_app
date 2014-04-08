module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update]

      def index
      end

      def show
      end

      def create
        @capsule = Capsule.new(capsule_params)
        @capsule.save
      end

      def update
        @capsule.update_attributes(capsule_params)
      end

      private

        def set_capsule
          @capsule = Capsule.find params[:id]
        end

        def capsule_params
          params.required(:capsule).permit(:user_id, :title, :location, :status, :payload_type, :promotional_state, :passcode, :visibility)
        end
    end
  end
end
