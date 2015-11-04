class ForwardLink
  ATTRIBUTES = [:email, :phone_number, :url]
  attr_accessor *ATTRIBUTES

  def initialize(email:, phone_number:, url:)
    @email = email
    @phone_number = phone_number
    @url = url
  end

  def read_attribute_for_serialization attribute
    send attribute
  end
end
