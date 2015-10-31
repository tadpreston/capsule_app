module API
  module V1a
    class CapsulesController < API::V1a::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy, :read, :unlock]
      before_action :set_pagination, only: [:index, :forme, :feed, :location]

      def index
        @capsule_index = CapsuleIndex.new current_user.id, @offset, @limit
        render json: @capsule_index, serializer: API::V1a::CapsuleFeedSerializer, root: false
      end

      def forme
        @received_capsules = ReceivedCapsules.new current_user, @offset, @limit
        render json: @received_capsules, serializer: API::V1a::CapsuleFeedSerializer, root: false
      end

      def feed
        @feed = Feed.new current_user.id, @offset, @limit
        render json: @feed, serializer: API::V1a::CapsuleFeedSerializer, root: false
      end

      def location
        @location = Location.new params[:latitude], params[:longitude], current_user.id, @offset, @limit
        render json: @location, serializer: API::V1a::CapsuleFeedSerializer, root: false
      end

      def show
        render json: @capsule, serializer: API::V1a::CapsuleSerializer
      rescue Exception => error
        NewRelic::Agent.notice_error error, custom_params: { params: params }
      end

      def create
        @capsule = current_user.capsules.build(capsule_params)
        if @capsule.save
          render json: @capsule, serializer: API::V1a::CapsuleSerializer
        else
          render_capsule_errors
        end
      end

      def update
        if @capsule.update_attributes(capsule_params)
          render json: @capsule, serializer: API::V1a::CapsuleSerializer
        else
          render_capsule_errors
        end
      end

      def destroy
        @capsule.remove_capsule current_user
        render json: { status: 'Deleted' }
      end

      def read
        @capsule.read current_user
        render json: @capsule, serializer: API::V1a::CapsuleSerializer
      end

      def unlock
        @capsule.unlock current_user
        render json: @capsule, serializer: API::V1a::CapsuleSerializer
      end

      def forward
        capsules = CapsuleForwarder.forward params[:capsule].merge(user_id: current_user.id)
        render json: capsules, each_serializer: API::V1a::CapsuleSerializer
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
        @capsule = Capsule.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render json: resource_not_found_response(:capsules, params[:id]), status: 404
      end

      def capsule_params
        params.required(:capsule).permit(:user_id, :comment, { location: [:name, :vicinity, :latitude, :longitude, :radius] }, :status, :payload_type, :promotional_state, :passcode, :location,
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
