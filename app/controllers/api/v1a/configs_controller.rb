module API
  module V1a
    class ConfigsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def index
      end
    end
  end
end
