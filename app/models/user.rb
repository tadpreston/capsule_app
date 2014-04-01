# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  public_id       :uuid
#  email           :string(255)
#  username        :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  password_digest :string(255)
#  location        :string(255)
#  provider        :string(255)
#  uid             :string(255)
#  authorized_at   :datetime
#  locale          :string(255)
#  time_zone       :string(255)
#  settings        :hstore
#  oauth           :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  before_save UserCallbacks
  before_validation UserCallbacks

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, if: "oauth.nil?"
  validate :uid_and_provider_are_unique, if: "oauth"
  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :devices

  protected

    def uid_and_provider_are_unique
      if User.exists?(provider: self.provider, uid: self.uid)
        errors.add(:uid, "already exists")
      end
    end
end
