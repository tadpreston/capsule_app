module API
  module V1

    class UsersController < API::V1::ApplicationController
      before_action :set_user, only: [:show, :update]
      skip_before_action :authorize_auth_token, only: [:index, :show, :create]

      def index
        @users = User.all.order(:last_name)
      end

      def show
      end

      def create
        @user = User.new(user_params)
        if @user.save
          @user.reload
          @device = @user.devices.create(remote_ip: request.remote_ip, user_agent: request.user_agent, last_sign_in_at: Time.now)
        end
      end

      def update
        @user.update_attributes(user_params)
      end

      private

        def set_user
          @user = User.find_by(public_id: params[:id])
        end

        def user_params
          params.required(:user).permit(:email, :username, :first_name, :last_name, :location, :password, :password_confirmation, :time_zone,
                                        oauth: [
                                          { location: [:id, :name] },
                                          :timezone, :updated_time, :name, :email, :birthdate, :locale, :first_name, :username, :id, :provider, :uid,
                                          :gender, :last_name, { hometown: [:id, :name] }, :link
                                        ]
                                       )

        end
    end
  end
end
