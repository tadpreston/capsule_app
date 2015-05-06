module API
  module V1a
    class HashtagsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def index
        origin = { lat: params[:latOrigin].to_f, long: params[:longOrigin].to_f }
        span = { lat: params[:latSpan].to_f, long: params[:longSpan].to_f }
        @hashtags = Capsule.find_hashtags(origin, span, params[:hashtag])
      end
    end
  end
end
