module API
  module V1

    class CapsulesController < API::V1::ApplicationController
      before_action :set_capsule, only: [:show, :update, :destroy, :portable, :remove_portable, :read, :unread, :watch, :unwatch, :like, :unlike]
      before_action :set_origin_span, only: [:explorer, :hidden, :locationtags]
      skip_before_action :authorize_auth_token, only: [:index, :explorer, :locationtags, :library, :read, :unread, :loadtest, :hidden, :show, :relative]

      def index
        @user = User.find params[:user_id]
        @capsules = @user.capsules
      end

      def watched
        user = params[:user_id] ? User.find(params[:user_id]) : current_user
        @capsules = user.watched_capsules
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
        hashtag = params[:hashtag].blank? ? '' : params[:hashtag]
        @capsule_boxes = Explorer.new(@origin, @span, hashtag).find_capsules
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

      def relative
        user_id = current_user ? current_user.id : nil
        tutorial_level = user_id ? current_user.tutorial_progress : 0
        @capsules = Capsule.relative_location(tutorial_level || 0, user_id)
      end

      def replies
        @capsules = Capsule.where('(TRIM(status) IS NULL)').where(in_reply_to: params[:id])
      end

      def replied_to
        capsule = Capsule.find params[:id]
        @capsule = capsule.replied_to
      end

      def read
        @capsule.read current_user
        if @capsule.location.nil?
          capsules = Capsule.relative_location(current_user.tutorial_progress)
          @all_read = true
          capsules.each { |capsule| @all_read = nil unless capsule.read_by?(current_user) }
          if @all_read
            current_user.update_attribute(:tutorial_progress, current_user.tutorial_progress + 1)
          end
        end
        render :show
      end

      def unread
        @capsule.unread current_user
        render :show
      end

      def watch
        @capsule.watch current_user
        render :show
      end

      def unwatch
        @capsule.unwatch current_user
        render :show
      end

      def like
        @capsule.like current_user
        render :show
      end

      def unlike
        @capsule.unlike current_user
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
                                           { relative_location: [:distance, :radius, :fixed_positioning, :tutorial_level] },
                                           comments_attributes: [:user_id, :body],
                                           assets_attributes: [:media_type, :resource, :metadata],
                                           recipients_attributes: [:phone_number, :email, :first_name, :last_name, :profile_image, :can_send_text])
        end

    end
  end
end
