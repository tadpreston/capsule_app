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
          @hashtags = Hashtag.where('tag ilike ?', "%#{query.match(/^.?(.*)/)[1]}%").order(:tag)
        elsif query.include?('@')
          user_query = query.split(' ').select { |s| s.include? '@' }.join
          @users = User.where('email = ? OR username = ?',  user_query, user_query.match(/^.?(.*)/)[1])
        else
          @capsules = Capsule.where('title ilike ? AND incognito = ? AND relative_location = NULL', "%#{query}%", false)
          @hashtags = Hashtag.where('tag ilike ?', "%#{query.match(/^.?(.*)/)[1]}%")
          @users = User.where('first_name ilike ? OR last_name ilike ?', "%#{query}%", "%#{query}%")
        end
      end
    end

  end
end
