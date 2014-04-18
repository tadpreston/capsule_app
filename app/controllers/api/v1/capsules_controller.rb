module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy]
      skip_before_action :authorize_auth_token, only: [:index]

      def index
        @user = User.find params[:user_id]
        @capsules = @user.capsules
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

      def destroy
        @capsule.destroy
        render json: { status: 'Deleted' }
      end

      def explorer
        @capsules = Capsule.find_in_rec({ lat: params[:lat].to_f, long: params[:long].to_f }, { lat: params[:latSpan].to_f, long: params[:longSpan].to_f } ).includes(:user)
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
          params.required(:capsule).permit(:user_id, :title, { location: [:latitude, :longitude, :radius] }, :status, :payload_type, :promotional_state, :passcode, :visibility,
                                           comments_attributes: [:user_id, :body],
                                           assets_attributes: [:media_type, :resource, :metadata])
        end
    end
  end
end
