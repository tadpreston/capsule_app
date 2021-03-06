module API
  module V1

    class ContactsController < API::V1::ApplicationController
      before_action :set_user
      before_action :set_contact, only: [:update, :destroy]
      skip_before_action :authorize_auth_token, only: [:index]

      def index
        @contacts = @user.contacts
      end

      def create
        @contact = Users::Search.find_or_create_by_phone_number(contact_params[:phone_number], contact_params.merge(provider: 'contact'))
        if @contact.persisted?
          @user.add_as_contact(@contact)
        else
          render :create, status: 422
        end
      end

      def destroy
        @user.contacts.delete(@contact)
        render json: { status: "Deleted" }
      end

      private

        def set_user
          @user = User.find params[:user_id]
        end

        def set_contact
          @contact = User.find params[:id]
        end

        def contact_params
          params.required(:contact).permit(:id, :email, :username, :full_name, :phone_number, :location, :uid)
        end
    end

  end
end
