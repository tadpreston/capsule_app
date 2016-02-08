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

  after_save :associate_user

  validates :email, presence: true

  belongs_to :user
  has_many :campaigns

  private

  def associate_user
    unless associate_user = User.find_by(email: email)
      associate_user = User.create email: email, password: password, password_confirmation: password_confirmation
    end
    update_columns user_id: associate_user.id
  end
end
