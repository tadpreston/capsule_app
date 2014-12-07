class RegisteredUser
  ATTRIBUTES = [:name, :phone_number]
  attr_accessor *ATTRIBUTES

  def initialize name: name, phone_number: phone_number
    @name = name
    @phone_number = phone_number
  end

  def self.find phone_numbers
    users = User.find_all_by_phone phone_numbers
    initialize_all_from_db users
  end

  private

  def self.initialize_all_from_db users
    users.map do |user|
      new name: user.full_name,
          phone_number: user.phone_number
    end
  end
end
