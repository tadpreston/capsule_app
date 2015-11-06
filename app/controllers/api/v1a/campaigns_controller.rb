module API
  module V1a
    class CampaignsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def redeem
        StarbucksCard.redeem params
        render json: { status: true }
      rescue StarbucksCardError
        render json: { status: false }, status: 400
      end
    end
  end
end
