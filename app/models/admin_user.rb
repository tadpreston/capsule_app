# == Schema Information
#
# Table name: admin_users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  auth_token      :string(255)
#

class AdminUser < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }

  def self.authenticate_user(email:, password:)
    if user = find_by(email: email).try(:authenticate, password)
      user.generate_auth_token
      user.save
      user
    end
  end

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while AdminUser.exists?(auth_token: self.auth_token)
  end
end
