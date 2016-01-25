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
end
