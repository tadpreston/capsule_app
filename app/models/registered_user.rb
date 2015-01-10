class RegisteredUser
  ATTRIBUTES = [:id, :name, :phone_number, :email, :profile_image]
  attr_accessor *ATTRIBUTES

  def initialize params
    @id = params[:id]
    @name = params[:name]
    @phone_number = params[:phone_number]
    @email = params[:email]
    @profile_image = params[:profile_image]
  end

  def self.find params
    users = User.find_all_registered_by_phone_or_email params
    initialize_all_from_db users
  end

  def read_attribute_for_serialization attribute
    send attribute
  end

  private

  def self.initialize_all_from_db users
    users.map do |user|
      new id: user.id,
          name: user.full_name,
          phone_number: user.phone_number,
          email: user.email,
          profile_image: user.profile_image
    end
  end
end
