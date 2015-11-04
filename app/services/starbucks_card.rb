class StarbucksCard
  @@amount = 500
  @@gift_card_sku = "SBUX-E-V-STD"

  def initialize(name, email)
    @name = name
    @email = email
  end

  def self.redeem(name, email)
    new(name, email).redeem
  end

  def redeem
    if(TangoCard.fund @@amount)
      recipient = TangoRecipient.new("Hi " + @name, @email)
      email = TangoEmail.new("PinYada", "Your coffee, from PinYada", "Someone wants to make your day.")

      return TangoCard.place_order("1", recipient, @@gift_card_sku, @@amount, email)
    end

    return nil
  end
end
