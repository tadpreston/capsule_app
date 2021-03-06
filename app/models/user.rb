# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  public_id              :uuid
#  email                  :string(255)
#  username               :string(255)
#  phone_number           :string(255)
#  password_digest        :string(255)
#  location               :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  authorized_at          :datetime
#  settings               :hstore
#  locale                 :string(255)
#  time_zone              :string(255)
#  oauth                  :hstore
#  created_at             :datetime
#  updated_at             :datetime
#  profile_image          :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  tutorial_progress      :integer          default(0)
#  recipient_token        :string(255)
#  comments_count         :integer          default(0)
#  facebook_username      :string(255)
#  twitter_username       :string(255)
#  motto                  :string(255)
#  background_image       :string(255)
#  job_id                 :string(255)
#  complete               :boolean          default(FALSE)
#  following              :integer          default([]), is an Array
#  watching               :integer          default([]), is an Array
#  can_send_text          :boolean
#  device_token           :string(255)
#  full_name              :string(255)
#  mode                   :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  converted_at           :datetime
#

class ValidationError < StandardError; end
class PasswordChangeError < StandardError; end
class User < ActiveRecord::Base
  has_secure_password

  after_create UserCallbacks

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :email, presence: true, if: Proc.new { |u| u.phone_number.blank? }
  validates :password, confirmation: true, unless: Proc.new { |u| u.password.blank? && u.password_confirmation.blank? }
  validates :phone_number, uniqueness: true, allow_blank: true
  validates :phone_number, presence: true, if: Proc.new { |u| u.email.blank? }

  has_many :devices, dependent: :destroy
  has_many :capsules, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_capsules, through: :favorites, source: :capsule
  has_many :comments, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :received_capsules, through: :recipient_users, source: :capsule
  has_many :contact_users
  has_many :contacts, through: :contact_users
  has_many :reads, class_name: 'CapsuleRead'
  has_many :read_capsules, through: :reads, source: :capsule
  has_many :location_watches
  has_many :objections
  has_many :assets, as: :assetable, dependent: :destroy
  has_many :notifications
  has_many :unlocks
  has_many :relevances
  has_many :relevant_yadas, through: :relevances, source: :capsule
  has_many :mandrill_results
  has_many :clients, dependent: :destroy

  delegate :auth_token, to: :current_device

  def self.generate_token(column)
    token = ''

    begin
      token = SecureRandom.urlsafe_base64
    end while User.exists?(column => token)

    token
  end

  def self.find_all_registered_by_phone_or_email query
    params = query.split ','
    where('phone_number IN (?) OR email IN (?)', params, params).where(provider: 'capsule')
  end

  def self.find_by_password_reset_token token
    find_by password_reset_token: token
  end

  def feed params = {}
    offset = params.fetch(:offset, 0).to_i
    limit = params.fetch(:limit, 0).to_i
    feed_capsules = capsules + received_capsules.includes(:user)
    feed_capsules.sort { |capsule1,capsule2| capsule2.updated_at <=> capsule1.updated_at }[offset..(offset+limit-1)]
  end

  def authenticate(password = nil)
    super(password)
  end

  def current_device
    @current_device ||= devices.order(last_sign_in_at: :desc).limit(1).take
  end

  def change_password params
    raise PasswordChangeError, 'Invalid Password' unless authenticate params[:old_password]
    raise PasswordChangeError, 'New Password does not match' unless params[:password] == params[:password_confirmation]
    update_attributes password: params[:password], password_confirmation: params[:password_confirmation]
  end

  def reset_password params
    raise PasswordChangeError, 'New Password does not match' unless params[:password] == params[:password_confirmation]
    update_attributes password: params[:password],
                      password_confirmation: params[:password_confirmation],
                      password_reset_token: nil, password_reset_sent_at: nil
  end

  def logged_in?
    current_device.has_token?
  end

  def has_device_token?
    !device_token.nil?
  end

  def has_email?
    !email.blank?
  end

  # Following and unfollowing

  def follow!(other_user)
    update_attributes(following: following + [other_user.id]) unless following?(other_user)
  end

  def following?(other_user)
    following.include?(other_user.id)
  end

  def unfollow!(other_user)
    update_attributes(following: following - [other_user.id])
  end

  def remove_follower!(other_user)
    other_user.update_attributes(following: following - [id])
  end

  # Who this users is following
  def followed_users
    cached_followed_users
  end

  # Who is following this user
  def followers
    User.where("following @> ARRAY[#{id}]").to_a
  end

  def watching_count
    following.size
  end

  def watchers_count
    followers.count
  end

# end of following

  def add_as_contact(contact)
    contacts << contact unless is_a_contact?(contact)
  end

  def is_a_contact?(contact)
    contacts.exists?(contact)
  end

  def send_confirmation_email
    generate_token(:confirmation_token)
    update_attributes(confirmation_sent_at: Time.now, confirmed_at: nil)
    UserMailerWorker.perform_async(self.id, :email_confirmation)
  end

  def email_confirmed!
    update_attribute(:confirmed_at, Time.now)
    update_columns(email: self.unconfirmed_email, unconfirmed_email: nil) if unconfirmed_email
  end

  def confirmed?
    confirmed_at
  end

  def watch_capsule(capsule)
    capsule.watch self
  end

  def unwatch_capsule(capsule)
    capsule.unwatch self
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

  def created_capsules
    cached_created_capsules.collect { |c| c.capsule_json.to_json }.join(',')
  end

  def cached_created_capsules
    Rails.cache.fetch([self, "created_capsules"]) do
      Capsule.capsules(id).to_a
    end
  end

  def watched_capsules
    cached_watched_capsules.collect { |c| c.capsule_json.to_json }.join(',')
  end

  def cached_watched_capsules
    Rails.cache.fetch([self, "watched_capsules"]) do
      Capsule.watched_capsules(id).to_a
    end
  end

  def location_watches_json
    cached_location_watches.collect { |l| l.watch_json.to_json }.join(',')
  end

  def cached_location_watches
    Rails.cache.fetch([self, 'location_watches']) { LocationWatch.location_watches(id).to_a }
  end

  def profile_image_path
    return '' if profile_image.blank?
    profile_image
  end

  def signed_profile_image_path
    return '' if profile_image.blank?
    UrlSigner.new("https://#{ENV['CLOUDFRONT_DOMAIN']}/#{profile_image}").signed_url
  end

  def background_image_path
    return '' if background_image.blank?
    background_image
  end

  def signed_background_image_path
    return '' if background_image.blank?
    UrlSigner.new("https://#{ENV['CLOUDFRONT_DOMAIN']}/#{background_image}").signed_url
  end

  def profile_asset
    assets.where(media_type: 'profile').take
  end

  def background_asset
    assets.where(media_type: 'background').take
  end

  def profile_asset
    assets.where(media_type: 'profile').take
  end

  def background_asset
    assets.where(media_type: 'background').take
  end

  def is_recipient?
    provider == 'recipient'
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def facebook_id=(facebook_id)
    self.facebook_username = facebook_id
  end

  private

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

  def cached_followed_users
    Rails.cache.fetch([self, "followed_users"]) do
      User.where(id: following).to_a
    end
  end

end
