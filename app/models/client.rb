# == Schema Information
#
# Table name: clients
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  name          :string(255)
#  email         :string(255)
#  profile_image :string(255)
#  created_by    :integer
#  updated_by    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Client < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  before_create :create_user

  belongs_to :user

  private

  def create_user
    unless user = User.find_by(email: email)
      user = User.create email: email, password: password, password_confirmation: password_confirmation
    end
    self.user_id = user.id
  end
end
