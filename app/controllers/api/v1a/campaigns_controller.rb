module API
  module V1a
    class CampaignsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def redeem
        render json: TangoCard.fund(500)
      end
    end
  end
end
