module API
  module V1
    class UpgradesController < API::V1::ApplicationController
      def index
        render json: { force_upgrade: false }
      end
    end
  end
end
