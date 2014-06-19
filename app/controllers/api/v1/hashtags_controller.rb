module API
  module V1

    class HashtagsController < API::V1::ApplicationController

      skip_before_action :authorize_auth_token

      def index
#        args = {}
#        if params[:latOrigin] && params[:latSpan]
#          args[:origin] = { lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }
#          args[:span] = { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }
#        end
#        args[:tag] = { tag: params[:hashtag] } if params[:hashtag]
#        @hashtags = Hashtag.find_location_hashtags(args)

        origin = { lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }
        span = { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }
        @hashtags = Capsule.find_hashtags(origin, span, params[:hashtag])
      end

    end
  end
end
