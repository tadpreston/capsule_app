module API
  module V1a
    class PromotionsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def redeem
        render json: { foo: "bar" }
      end
    end
  end
end
