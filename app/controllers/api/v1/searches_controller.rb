module API
  module V1

    class SearchesController < API::V1::ApplicationController
      skip_before_action :authorize_auth_token

      def index
        @users = []
        @capsules = []
        @hashtags = []
        query = params[:query]

        if query[0] == '#'
          @hashtags = Capsule.search_hashtags(query)
        elsif query.include?('@')
          @users = User.search_by_identity(query)
        else
          @capsules = Capsule.search_capsules(query, current_user)
          @hashtags = Capsule.search_hashtags(query)
          @users = User.search_by_name(query)
        end
      end
    end

  end
end
