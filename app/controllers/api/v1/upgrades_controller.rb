module API
  module V1
    class UpgradesController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token

      def index
        render json: { force_upgrade: true }
      end
    end
  end
end
