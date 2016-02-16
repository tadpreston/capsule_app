module Admin
  class UsersController < Admin::ApplicationController
    def index
      if params[:q].blank?
        users = User.all.order(:last_name).limit(100)
      else
        q = "%#{params[:q]}%"
        users = User.where('full_name ilike ? OR email ilike ?', q, q).order(:email)
      end
      render json: users, each_serializer: Admin::UserSerializer
    end
  end
end
