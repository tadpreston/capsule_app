module API
  module V1

    class ContactsController < API::V1::ApplicationController
      before_action :set_user
      before_action :set_contact, only: [:update, :destroy]

      def index
        @contacts = @user.contacts
      end

      def create
        @contact = User.new(contact_params)
        tmp_pwd = SecureRandom.hex
        @contact.password = tmp_pwd
        @contact.password_confirmation = tmp_pwd
        if @contact.save
          @user.contacts << @contact
        else
          render :create, status: 422
        end
      end

      def update
        render :update, status: 422 unless @contact.update_attributes(contact_params)
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
          params.required(:contact).permit(:email, :username, :first_name, :last_name, :phone_number, :location)
        end
    end

  end
end
