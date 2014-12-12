class RegisteredUser
  ATTRIBUTES = [:name, :phone_number]
  attr_accessor *ATTRIBUTES

  def initialize name: name, phone_number: phone_number
    @name = name
    @phone_number = phone_number
  end

  def self.find params
    users = User.find_all_by_phone_or_email params
    initialize_all_from_db users
  end

  def read_attribute_for_serialization attribute
    send attribute
  end

  private

  def self.initialize_all_from_db users
    users.map do |user|
      new name: user.full_name,
          phone_number: user.phone_number
    end
  end
end
