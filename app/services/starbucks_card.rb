class StarbucksCard
  attr_reader :email, :yada_id, :access_token

  GIFT_CARD_AMOUNT = 500
  GIFT_CARD_SKU = "SBUX-E-V-STD"

  def initialize params
    @email = params[:email]
    @yada_id = params[:yada_id]
    @access_token = params[:access_token]
  end

  def self.redeem params
    new(params).redeem
  end

  def redeem
    if redeemable? && TangoCard.fund(GIFT_CARD_AMOUNT)
      recipient = TangoRecipient.new("Hi #{recipient_name}", email)
      tango_email = TangoEmail.new("PinYada", "Your coffee, from PinYada", "Someone wants to make your day.")
      result = TangoCard.place_order(campaign.name, recipient, GIFT_CARD_SKU, GIFT_CARD_AMOUNT, tango_email)
      create_transaction result
      self
    else
      raise StarbucksCardError
    end
  end

  private

  def redeemable?
    campaign && campaign.budget_room? && !campaign.redeemed?(user)
  end

  def yada
    @yada ||= yada_id ? Capsule.find(yada_id) : Capsule.find_by(access_token: access_token)
  end

  def user
    @user ||= yada.user
  end

  def campaign
    @campaign ||= yada ? yada.campaign : nil
  end

  def recipient_name
    user.full_name || 'Friend'
  end

  def create_transaction result
    campaign.campaign_transactions.create capsule_id: yada.id, user_id: user.id, order_id: result['order']['order_id'], amount: GIFT_CARD_AMOUNT / 100
  end
end
