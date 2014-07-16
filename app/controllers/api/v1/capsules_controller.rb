module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy, :portable, :remove_portable]
      before_action :set_origin_span, only: [:explorer, :hidden, :locationtags]
      skip_before_action :authorize_auth_token, only: [:index, :explorer, :locationtags, :library, :read, :unread, :loadtest, :hidden, :show]

      def index
        @user = User.find params[:user_id]
        @capsules = @user.capsules
#       render json: @capsules
      end

      def watched
        user = params[:user_id] ? User.find(params[:user_id]) : current_user
        @capsules = user.watched_capsules.by_updated_at.includes(:user)
      end

      def show
#       render json: @capsule
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
        hashtag = params[:hashtag].blank? ? '' : params[:hashtag]
        @capsule_boxes = Explorer.new(@origin, @span, hashtag).find_capsules
#       render json: @capsule_boxes, meta: { capsule_count: @capsule_boxes.size }
      end

      def locationtags
        @capsules = Capsule.find_location_hash_tags(@origin, @span, params[:hashtags].gsub(/[|]/,' '))
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
          @user_capsules = current_user.cached_capsules
        end
        @suggested_capsules = Capsule.find_in_rec({ lat: 33.2342834, long: -97.5861393 }, { lat: 1.4511453, long: 1.7329357 }).includes(:user).limit(5)  # This is temporary until a suggested algorithm is developed
      end

      def hidden
        @capsules = Capsule.find_hidden_in_rec(@origin, @span)
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
        @capsule.reads << current_user.id
        @capsule.save
        render :show
      end

      def unread
        @capsule = Capsule.find params[:id]
        @capsule.reads.delete current_user.id
        @capsule.save
        render :show
      end

      def watch
        @capsule = Capsule.find params[:id]
        @capsule.watch current_user
        @capsule.save
        render :show
      end

      def unwatch
        @capsule = Capsule.find params[:id]
        @capsule.unwatch current_user
        @capsule.save
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
        @capsules = Capsule.all.includes(:user, :assets, :recipients, :comments)
        render json: @capsules
      end

      private

        def set_capsule
          begin
            @capsule = Capsule.find params[:id]
          rescue
            render json: { status: 'Not Found', response: { errors: [ { capsule: [ "Not found with id: #{params[:id]}" ] } ] } }, status: 404
          end
        end

        def set_origin_span
          @origin = { lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }
          @span = { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }
        end

        def capsule_params
          params.required(:capsule).permit(:user_id, :title, { location: [:latitude, :longitude, :radius] }, :status, :payload_type, :promotional_state, :passcode,
                                           :visibility, :thumbnail, :in_reply_to, :is_portable, :start_date, :lock_question, :lock_answer, :is_incognito,
                                           { relative_location: [:radius] },
                                           comments_attributes: [:user_id, :body],
                                           assets_attributes: [:media_type, :resource, :metadata],
                                           recipients_attributes: [:phone_number, :email, :first_name, :last_name, :profile_image])
        end
    end
  end
end
