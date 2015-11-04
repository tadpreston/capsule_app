module API
  module V1a
    class TangoRecipient
      attr_accessor :name, :email

      def initialize(name, email)
        @name = name
        @email = email
      end
    end

    class TangoEmail
      attr_accessor :from, :subject, :message

      def initialize(from, subject, message)
        @from = from
        @subject = subject
        @message = message
      end
    end

    class CampaignsController < API::V1a::ApplicationController
      skip_before_action :authorize_auth_token

      def redeem
        # render json: TangoCard.fund(500)
        recipient = TangoRecipient.new("Hi Drew", "drewbuysstuff@gmail.com")
        email = TangoEmail.new("PinYada", "Your coffee, from PinYada", "Someone wants to make your day.")
        render json: TangoCard.place_order("1", recipient, "SBUX-E-V-STD", 500, email)
      end
    end
  end
end
