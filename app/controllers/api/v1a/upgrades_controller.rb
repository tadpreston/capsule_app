module API
  module V1a
    class UpgradesController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def index
        render json: { force_upgrade: false }
      end
    end
  end
end
