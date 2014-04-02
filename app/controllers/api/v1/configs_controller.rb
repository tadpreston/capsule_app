module API
  module V1

    class ConfigsController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token

      def index
      end
    end
  end
end
