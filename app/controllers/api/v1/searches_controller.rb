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
          @capsules = Capsule.where('title ilike ?', "%#{query}%")
                             .where(incognito: false)
                             .where(relative_location: nil)
                             .joins('LEFT OUTER JOIN recipient_users r ON r.capsule_id = capsules.id')
          if current_user
            @capsules = @capsules.where('r.id IS NULL OR r.user_id = ?', current_user.id)
          else
            @capsules = @capsules.where('r.id IS NULL')
          end
          @hashtags = Hashtag.where('tag ilike ?', "%#{query}%")
          @users = User.where('first_name ilike ? OR last_name ilike ?', "%#{query}%", "%#{query}%")
        end
      end
    end

  end
end
