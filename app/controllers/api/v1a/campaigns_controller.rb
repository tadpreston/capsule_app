module API
  module V1a
    class CampaignsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def redeem
        if(params[:email] && params[:yada_id])
          yada = Capsule.find params[:yada_id]
          render json: StarbucksCard.redeem(yada.user.username || "Friend", params[:email])
        else
          render json: { "success" => "bad params" }
        end
      end
    end
  end
end
