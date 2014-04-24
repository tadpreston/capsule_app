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
#  phone_number    :string(255)
#  password_digest :string(255)
#  location        :string(255)
#  provider        :string(255)
#  uid             :string(255)
#  authorized_at   :datetime
#  settings        :hstore
#  locale          :string(255)
#  time_zone       :string(255)
#  oauth           :hstore
#  created_at      :datetime
#  updated_at      :datetime
#  profile_image   :string(255)
#

class User < ActiveRecord::Base
  before_save UserCallbacks
  before_validation UserCallbacks

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, if: "oauth.nil?"
  validate :uid_and_provider_are_unique, if: "oauth"
  has_secure_password
  validates :password, confirmation: true, length: { minimum: 6 }, unless: Proc.new { |u| u.password.blank? && u.password_confirmation.blank? }

  has_many :devices, dependent: :destroy
  has_many :capsules, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_capsules, through: :favorites, source: :capsule
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships
  has_many :comments, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :received_capsules, through: :recipient_users, source: :capsule
  has_many :contact_users
  has_many :contacts, through: :contact_users

  def self.find_or_create_by_oauth(oauth)
    User.find_or_create_by(provider: oauth[:provider], uid: oauth[:uid].to_s) do |user|
      user.oauth = oauth
    end
  end

  def self.find_or_create_by_phone_number(phone_number, user_attributes = {})
    User.find_or_create_by(phone_number: phone_number) do |user|
      user.email = user_attributes[:email]
      user.first_name = user_attributes[:first_name]
      user.last_name = user_attributes[:last_name]
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
    end
  end

  def authenticate(password = nil)
    if password
      super(password)
    elsif oauth
      self
    else
      false
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def add_as_contact(contact)
    contacts << contact unless is_a_contact?(contact)
  end

  def is_a_contact?(contact)
    contacts.exists?(contact)
  end

  protected

    def uid_and_provider_are_unique
      unless self.persisted?
        if User.exists?(provider: self.provider, uid: self.uid)
          errors.add(:uid, "already exists")
        end
      end
    end
end
