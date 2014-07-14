# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  public_id            :uuid
#  email                :string(255)
#  username             :string(255)
#  first_name           :string(255)
#  last_name            :string(255)
#  phone_number         :string(255)
#  password_digest      :string(255)
#  location             :string(255)
#  provider             :string(255)
#  uid                  :string(255)
#  authorized_at        :datetime
#  settings             :hstore
#  locale               :string(255)
#  time_zone            :string(255)
#  oauth                :hstore
#  created_at           :datetime
#  updated_at           :datetime
#  profile_image        :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  unconfirmed_email    :string(255)
#  tutorial_progress    :integer          default(0)
#  recipient_token      :string(255)
#  comments_count       :integer          default(0)
#  facebook_username    :string(255)
#  twitter_username     :string(255)
#  motto                :string(255)
#  background_image     :string(255)
#

class User < ActiveRecord::Base
  before_save UserCallbacks
  before_validation UserCallbacks, unless: Proc.new { |user| user.persisted? }
  after_commit UserCallbacks
  after_create UserCallbacks, unless: Proc.new { |user| user.provider == 'contact' }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
# validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, if: "oauth.nil?"
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, :if => Proc.new { |user| user.email_changed? }
  validate :uid_and_provider_are_unique, if: "oauth"
  has_secure_password
  validates :password, confirmation: true, length: { minimum: 6 }, unless: Proc.new { |u| u.password.blank? && u.password_confirmation.blank? }

  has_many :devices, dependent: :destroy
  has_many :capsules, -> { where 'TRIM(status) IS NULL' }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_capsules, -> { where 'TRIM(status) IS NULL' }, through: :favorites, source: :capsule
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships
  has_many :comments, -> { where 'TRIM(status) IS NULL' }, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :received_capsules, -> { where 'TRIM(status) IS NULL' }, through: :recipient_users, source: :capsule
  has_many :contact_users
  has_many :contacts, through: :contact_users
  has_many :reads, class_name: 'CapsuleRead'
  has_many :read_capsules, -> { where 'TRIM(status) IS NULL' }, through: :reads, source: :capsule
  has_many :capsule_watches
  has_many :watched_capsules, -> { where 'TRIM(status) IS NULL' }, through: :capsule_watches, source: :capsule
  has_many :location_watches
  has_many :objections

  def watching_count
    relationships.count
  end

  def watchers_count
    reverse_relationships.count
  end

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
      user.provider = user_attributes[:provider] || 'capsule'
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
    end
  end

  def self.find_or_create_recipient(attributes)
    args = attributes[:email] ? { email: attributes[:email] } : { phone_number: attributes[:phone_number] }

    find_or_create_by(args) do |user|
      user.instance_eval('generate_token(:recipient_token)')
      tmp_pwd = SecureRandom.hex
      user.password = tmp_pwd
      user.password_confirmation = tmp_pwd
      user.provider = 'recipient'
      attributes.each do |key, val|
        user[key] = val
      end
    end
  end

  def self.generate_token(column)
    token = ''

    begin
      token = SecureRandom.urlsafe_base64
    end while User.exists?(column => token)

    token
  end

  def self.search_by_identity(query)
    user_query = query.split(' ').select { |s| s.include? '@' }.join
    if user_query[0] == '@'
      where(username: user_query.match(/^.?(.*)/)[1])
    else
      where(email: user_query)
    end
  end

  def self.search_by_name(query)
    user_query = query.split
    where_clause = []
    user_query.each do |q|
      where_clause << '(' + %w[first_name last_name].map { |column| "#{column} ilike '%#{q}%'" }.join(' OR ') + ')'
    end
    where(where_clause.join(' AND '))
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
    relationships.create!(followed_id: other_user.id) unless following?(other_user)
  end

  def remove_follower!(other_user)
    followers.delete(other_user)
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

  def send_confirmation_email
    generate_token(:confirmation_token)
    self.confirmation_sent_at = Time.now
    self.confirmed_at = nil
    save!
    UserMailerWorker.perform_async(self.id, :email_confirmation)
  end

  def email_confirmed!
    self.confirmed_at = Time.now
    save!
    update_columns(email: self.unconfirmed_email, unconfirmed_email: nil)
  end

  def confirmed?
    self.confirmed_at
  end

  def watch_capsule(capsule)
    watched_capsules << capsule unless capsule.user_id == id
  end

  def unwatch_capsule(capsule)
    watched_capsules.delete(capsule)
  end

  def is_watching_capsule?(capsule)
    cached_watched_capsules.include? capsule
  end

  def cached_favorite_capsules
    Rails.cache.fetch(["favorite_capsules", self]) { favorite_capsules.by_updated_at.to_a }
  end

  def cached_received_capsules
    Rails.cache.fetch(["received_capsules", self]) { received_capsules.to_a }
  end

  def cached_capsules
    Rails.cache.fetch(["capsules", self]) { capsules.by_updated_at.to_a }
  end

  def json_capsules
    cached_json_capsules.map do |c|
      capsule_json = c.capsule_json
      capsule_json["is_watched"] = c.watched_by?(id)
      capsule_json["is_read"] = c.read_by?(id)
      capsule_json.to_json
    end.join(',')
  end

  def cached_json_capsules
    Rails.cache.fetch([self, "json_capsules"]) do
      Capsule.users_capsules(id).to_a
    end
  end

  def cached_watched_capsules
    Rails.cache.fetch(["watched_capsules", self]) { watched_capsules.by_updated_at.to_a }
  end

  def cached_location_watches
    Rails.cache.fetch(["location_watches", self]) { location_watches.to_a }
  end

  def cached_followed_users
    Rails.cache.fetch(["followed_users", self]) { followed_users.to_a }
  end

  def cached_followers
    Rails.cache.fetch(["followers", self]) { followers.to_a }
  end

  def cached_followed_users
    Rails.cache.fetch(["followed_users", self]) { followed_users.to_a }
  end

  def is_following?(user)
    cached_followed_users.include?(user)
  end

  protected

    def uid_and_provider_are_unique
      unless self.persisted?
        if User.exists?(provider: self.provider, uid: self.uid)
          errors.add(:uid, "already exists")
        end
      end
    end

    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

end
