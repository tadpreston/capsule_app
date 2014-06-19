# == Schema Information
#
# Table name: capsules
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  title             :string(255)
#  hash_tags         :string(255)
#  location          :hstore
#  status            :string(255)
#  visibility        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  lock_question     :string(255)
#  lock_answer       :string(255)
#  latitude          :decimal(, )
#  longitude         :decimal(, )
#  payload_type      :integer
#  promotional_state :integer
#  relative_location :hstore
#  incognito         :boolean
#  in_reply_to       :integer
#  comments_count    :integer          default(0)
#  likes_store       :hstore
#  is_portable       :boolean
#  thumbnail         :string(255)
#  start_date        :datetime
#

class Capsule < ActiveRecord::Base
  include PgSearch
  include IsLikeable

  attr_reader :recipients_attributes

  is_likeable :likes_store

  before_save CapsuleCallbacks
  after_save CapsuleCallbacks
  after_create CapsuleCallbacks

  validates :title, presence: true

  belongs_to :user, touch: true
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :assets, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :recipients, through: :recipient_users, source: :user
  has_many :replies, class_name: "Capsule", foreign_key: "in_reply_to"
  belongs_to :replied_to, class_name: "Capsule", foreign_key: "in_reply_to", touch: true
  has_many :reads, class_name: 'CapsuleRead'
  has_many :read_by, through: :reads, source: :user
  has_many :capsule_watches
  has_many :watchers, through: :capsule_watches, source: :user
  has_many :portable_capsules
  has_many :objections, as: :objectionable, dependent: :destroy

  delegate :full_name, to: :user, prefix: true

  scope :by_updated_at, -> { order(updated_at: :desc) }

  # pg_search_scope :search_by_hashtags, against: :hash_tags, using: { tsearch: { dictionary: "english" } }

  accepts_nested_attributes_for :comments, allow_destroy: true
  accepts_nested_attributes_for :assets, allow_destroy: true

  PAYLOAD_TYPES = [NO_VALUE_TYPE = 'NoValue', AUDIO_TYPE = 'Audio', VIDEO_TYPE = 'Video', PICTURE_TYPE = 'Picture', TEXT_TYPE = 'Text']
  PROMOTIONAL_STATES = ["NoValue", "Promo State One", "Promo State Two", "Promo State Three", "Promo State Four"]
  BOX_RANGE = 0.1

  def self.find_in_rec(origin, span)
    east_bound = origin[:long] + span[:long]
    south_bound = origin[:lat] - span[:lat]
    where(longitude: (origin[:long]..east_bound), latitude: (south_bound..origin[:lat]))
  end

  def self.find_from_center(origin, span)
    west_bound = origin[:long] - span[:long]
    east_bound = origin[:long] + span[:long]
    north_bound = origin[:lat] + span[:lat]
    south_bound = origin[:lat] - span[:lat]
    where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound))
  end

  def self.with_hash_tag(tag)
    where('hash_tags ilike ?', "%#{tag}%")
  end

  def self.find_location_hash_tags(origin, span, tag = nil)
    capsules = find_in_rec(origin, span)
    capsules = capsules.with_hash_tag(tag) if tag
    capsules.includes(:user, :assets, :recipients)
  end

  def self.find_hidden_in_rec(origin, span)
    find_in_rec(origin, span).where(incognito: true).includes(:user, :assets, :recipients)
  end

  def self.find_in_boxes(origin, span, hashtag)
    start_lat = truncate_decimals(origin[:lat].to_f - span[:lat].to_f)
    end_lat = truncate_decimals(origin[:lat].to_f) + 0.1
    start_long = truncate_decimals(origin[:long].to_f) - 0.1
    end_long = truncate_decimals(origin[:long].to_f + span[:long].to_f)

    capsules = Capsule.where("trunc(latitude,1) BETWEEN ? AND ? AND trunc(longitude,1) BETWEEN ? AND ?",start_lat,end_lat,start_long,end_long)
    capsules = capsules.where("title ilike ?", "%#{hashtag}%") unless hashtag.blank?
    capsules
  end

  def self.truncate_decimals(value, places = 1)
    precision = 10**places
    (value * precision).to_i / precision.to_f
  end

  def self.cached_boxes(sql, name)
    Rails.cache.fetch([name, "boxes"]) { find_by_sql sql }
  end

  def self.start_point(point)
    (point.abs.round + (point.abs.modulo(1) < BOX_RANGE ? BOX_RANGE : 0)) * (point < 0 ? -1 : 1)
  end

  def purged_title
    title.slice(/^[^#]*\b/)
  end

  def thumbnail_path
    unless self.thumbnail.blank?
      if self.thumbnail.include?('/')
        "https://#{ENV['CDN_HOST']}/#{self.thumbnail}"
      else
        "https://#{ENV['CDN_HOST']}/default/waiting.png"
#       "http://res.cloudinary.com/demo/image/upload/w_320,h_313,c_thumb,g_face/butterfly.jpg"
      end
    else
      "http://res.cloudinary.com/demo/image/upload/w_320,h_313,c_thumb,g_face/butterfly.jpg"
    end
  end

  def recipients_attributes=(recipients)
    @recipients_attributes = recipients
  end

  def add_as_recipient(recipient)
    recipients << recipient unless is_a_recipient?(recipient)
  end

  def is_a_recipient?(recipient)
    cached_recipients.include?(recipient)
  end

  def read_by?(user)
    cached_read_by.include?(user)
  end

  def watched_by?(user)
    cached_watchers.include?(user)
  end

  def is_processed?
    processed_flag = true
    cached_assets.each { |asset| processed_flag = false if asset.complete == false }
    processed_flag
  end

  def hash_tags_array
    self.hash_tags.split(' ')
  end

  def liked_by?(user)
    if user
      likes.include?(user.id)
    else
      false
    end
  end

  def likes_count
    likes.size
  end

  def is_incognito=(value)
    self.incognito = value
  end

  def is_incognito
    self.incognito
  end

  # Caching associations
  # TODO Refactor this into a module

  def cached_user
    Rails.cache.fetch(["capsule/author", self]) { user }
  end

  def cached_recipients
    Rails.cache.fetch(["capsule/recipients", self]) { recipients.to_a }
  end

  def cached_assets
    Rails.cache.fetch(["capsule/assets", self]) { assets.to_a }
  end

  def cached_comments
    Rails.cache.fetch(["capsule/comments", self]) { comments.to_a }
  end

  def cached_read_by
    Rails.cache.fetch(["capsule/read_by", self]) { read_by.to_a }
  end

  def cached_watchers
    Rails.cache.fetch(["capsule/watchers", self]) { watchers.to_a }
  end
end
