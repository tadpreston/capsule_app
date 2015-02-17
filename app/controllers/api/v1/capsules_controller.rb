module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy, :read, :unread]
      before_action :set_pagination, only: [:index, :forme, :feed, :location]
      skip_before_action :authorize_auth_token

      def index
        @capsule_index = CapsuleIndex.new current_user.id, @offset, @limit
        render json: @capsule_index, serializer: CapsuleFeedSerializer, root: false
      end

      def forme
        @received_capsules = ReceivedCapsules.new current_user, @offset, @limit
        render json: @received_capsules, serializer: CapsuleFeedSerializer, root: false
      end

      def feed
        @feed = Feed.new current_user.id, @offset, @limit
        render json: @feed, serializer: CapsuleFeedSerializer, root: false
      end

      def location
        @location = Location.new params[:latitude], params[:longitude], current_user.id, @offset, @limit
        render json: @location, serializer: CapsuleFeedSerializer, root: false
      end

      def show
        render json: @capsule, serializer: CapsuleSerializer
      end

      def create
        @capsule = current_user.capsules.build(capsule_params)
        if @capsule.save
          render json: @capsule, serializer: CapsuleSerializer
        else
          render_capsule_errors
        end
      end

      def update
        if @capsule.update_attributes(capsule_params)
          render json: @capsule, serializer: CapsuleSerializer
        else
          render_capsule_errors
        end
      end

      def destroy
        @capsule.destroy
        render json: { status: 'Deleted' }
      end

      def read
        @capsule.read current_user
        render json: @capsule, serializer: CapsuleSerializer
      end

      private

      def render_capsule_errors
        render status: 422, json: {
          errors: [
            status: '422',
            code: '422',
            title: @capsule.errors,
            links: [],
            path: request.env['REQUEST_PATH']
          ]
        }
      end

      def set_capsule
        begin
          @capsule = Capsule.find params[:id]
        rescue
          render json: { status: 'Not Found', response: { errors: [ { capsule: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
        end
      end

      def capsule_params
        params.required(:capsule).permit(:user_id, :comment, { location: [:name, :latitude, :longitude, :radius] }, :status, :payload_type, :promotional_state, :passcode,
                                         :visibility, :thumbnail, :in_reply_to, :is_portable, :start_date, :lock_question, :lock_answer, :is_incognito,
                                         { relative_location: [:distance, :radius, :fixed_positioning, :tutorial_level] },
                                         comments_attributes: [:user_id, :body],
                                         assets_attributes: [:media_type, :resource_path, :metadata],
                                         recipients_attributes: [:phone_number, :email, :full_name, :profile_image, :can_send_text])
      end

      def set_pagination
        @offset = params.fetch(:offset, 0)
        @limit = params.fetch(:limit, 500)
      end
    end
  end
end
