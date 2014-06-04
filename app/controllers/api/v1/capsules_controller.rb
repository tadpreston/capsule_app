module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy, :portable, :remove_portable]
      skip_before_action :authorize_auth_token, only: [:index, :explorer, :locationtags, :library, :read, :unread, :loadtest]

      def index
        @user = User.find params[:user_id]
        @capsules = @user.capsules
      end

      def watched
        user = params[:user_id] ? User.find(params[:user_id]) : current_user
        @capsules = user.watched_capsules.by_updated_at.includes(:user)
      end

      def show
      end

      def create
        @capsule = current_user.capsules.build(capsule_params)
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
        origin = { lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }
        span = { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }

        if span[:lat].to_f > 0.2
#         render json: { status: 'Success', response: Capsule.find_boxes(origin, span) }
          @boxes = Capsule.find_boxes(origin, span)
          render :explorer_boxes
        else
          @capsules = Capsule.find_in_boxes(origin,span)
        end

#        if span[:lat] > Capsule::BOX_RANGE || span[:long] > Capsule::BOX_RANGE
#          #large rect response
#          boxes = Capsule.find_boxes(origin, span)
#          render json: { status: 'Success', 'response' => boxes }
#        else
#          # small rect response
#          tag = params[:hashtag]
#          @capsules = Capsule.find_location_hash_tags(origin, span, tag)
#        end
      end

      def locationtags
        @capsules = Capsule.find_location_hash_tags({ lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }, { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }, params[:hashtags].gsub(/[|]/,' '))
        @capsule_count = @capsules.count(:all)
      end

      def forme
        @capsules = current_user.received_capsules.includes(:user)
      end

      def suggested
        @capsules  = Capsule.find_in_rec({ lat: 33.2342834, long: -97.5861393 }, { lat: 1.4511453, long: 1.7329357 }).includes(:user).limit(5)
      end

      def library
        @watched_capsules = []
        @capsules_forme = []
        @user_capsules = []
        if current_user
          @watched_capsules = current_user.cached_favorite_capsules
          @capsules_forme = current_user.cached_received_capsules
          @user_capsules = current_user.cached_capsules.by_updated_at
        end
        @suggested_capsules = Capsule.find_in_rec({ lat: 33.2342834, long: -97.5861393 }, { lat: 1.4511453, long: 1.7329357 }).includes(:user).limit(5)  # This is temporary until a suggested algorithm is developed
      end

      def replies
        capsule = Capsule.find params[:id]
        @capsules = capsule.replies
      end

      def replied_to
        capsule = Capsule.find params[:id]
        @capsule = capsule.replied_to
      end

      def read
        @capsule = Capsule.find params[:id]
        @capsule.read_by << current_user
        render :show
      end

      def unread
        @capsule = Capsule.find params[:id]
        @capsule.read_by.delete current_user
        render :show
      end

      def watch
        @capsule = Capsule.find params[:id]
        @capsule.watchers << current_user
        render :show
      end

      def unwatch
        @capsule = Capsule.find params[:id]
        @capsule.watchers.delete current_user
        render :show
      end

      def like
        @capsule = Capsule.find params[:id]
        @capsule.likes << current_user.id
        @capsule.save
        render :show
      end

      def unlike
        @capsule = Capsule.find params[:id]
        @capsule.likes.delete current_user.id
        @capsule.save
        render :show
      end

      def loadtest
        @capsules = Capsule.all.includes(:user, :assets, :recipients)
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
          params.required(:capsule).permit(:user_id, :title, { location: [:latitude, :longitude, :radius] }, :status, :payload_type, :promotional_state, :passcode,
                                           :visibility, :thumbnail, :in_reply_to, :is_portable, :start_date,
                                           { relative_location: [:radius] },
                                           comments_attributes: [:user_id, :body],
                                           assets_attributes: [:media_type, :resource, :metadata],
                                           recipients_attributes: [:phone_number, :email, :first_name, :last_name])
        end
    end
  end
end
