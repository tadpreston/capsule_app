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
  belongs_to :replied_to, class_name: "Capsule", foreign_key: "in_reply_to"
  has_many :reads, class_name: 'CapsuleRead'
  has_many :read_by, through: :reads, source: :user
  has_many :capsule_watches
  has_many :watchers, through: :capsule_watches, source: :user
  has_many :portable_capsules

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

  def self.find_boxes_orig(origin, span, range = BOX_RANGE)
    box_span = span[:lat].to_f >= 2 ? 0.5 : 0.2

    start_lat = (truncate_decimals((origin[:lat] - span[:lat]) / box_span, 0) * box_span).round(1)
    end_lat = (truncate_decimals(origin[:lat].to_f / box_span, 0) * box_span).round(1)
    start_long = (truncate_decimals(origin[:long].to_f / box_span, 0) * box_span) - box_span
    end_long = truncate_decimals((origin[:long].to_f + span[:long].to_f) / box_span, 0) * box_span

    sql = <<-SQL
      SELECT (trunc(latitude / #{box_span}) * #{box_span}) as lat, (trunc(longitude / #{box_span}) * #{box_span}) as lon, median(latitude) as med_lat, median(longitude) as med_long, count(*)
      FROM capsules
      WHERE (latitude BETWEEN #{start_lat} AND #{end_lat}) AND (longitude BETWEEN #{start_long} AND #{end_long})
      GROUP BY lat, lon
      ORDER BY lat,lon;
    SQL

    boxed_capsules = cached_boxes(sql, "#{start_lat},#{end_long}")

    boxes = boxed_capsules.map { |bc| { name: "#{bc.lat},#{bc.lon}", center_lat: bc.med_lat, center_long: bc.med_long, count: bc.count } }

    { boxes: boxes }
  end

  def self.find_boxes(origin, span, range = BOX_RANGE)
    box_span = span[:lat].to_f >= 2 ? 0.5 : 0.2

    start_lat = (truncate_decimals((origin[:lat] - span[:lat]) / box_span, 0) * box_span).round(1)
    end_lat = (truncate_decimals(origin[:lat].to_f / box_span, 0) * box_span).round(1)
    start_long = (truncate_decimals(origin[:long].to_f / box_span, 0) * box_span) - box_span
    end_long = truncate_decimals((origin[:long].to_f + span[:long].to_f) / box_span, 0) * box_span

    sql = <<-SQL
      SELECT (trunc(latitude / #{box_span}) * #{box_span}) as lat, (trunc(longitude / #{box_span}) * #{box_span}) as lon, median(latitude) as med_lat, median(longitude) as med_long, count(*)
      FROM capsules
      WHERE (latitude BETWEEN #{start_lat} AND #{end_lat}) AND (longitude BETWEEN #{start_long} AND #{end_long})
      GROUP BY lat, lon
      ORDER BY lat,lon;
    SQL

    boxed_capsules = find_by_sql sql

    boxed_capsules.map { |bc| { name: "#{bc.lat},#{bc.lon}", center_lat: bc.med_lat, center_long: bc.med_long, count: bc.count } }
  end

  def self.find_in_boxes(origin, span)
    start_lat = truncate_decimals(origin[:lat].to_f - span[:lat].to_f)
    end_lat = truncate_decimals(origin[:lat].to_f) + 0.1
    start_long = truncate_decimals(origin[:long].to_f) - 0.1
    end_long = truncate_decimals(origin[:long].to_f + span[:long].to_f)

    Capsule.where("trunc(latitude,1) BETWEEN ? AND ? AND trunc(longitude,1) BETWEEN ? AND ?",start_lat,end_lat,start_long,end_long).includes(:user, :assets, :recipients)
  end

  def self.truncate_decimals(value, places = 1)
    precision = 10**places
    (value * precision).to_i / precision.to_f
  end

  def self.cached_boxes(sql, name)
    Rails.cache.fetch([name, "boxes"]) do
      find_by_sql sql
    end
  end

  def self.start_point(point)
    (point.abs.round + (point.abs.modulo(1) < BOX_RANGE ? BOX_RANGE : 0)) * (point < 0 ? -1 : 1)
  end

  def self.to_hash(collection)
    collection.map do |capsule|
      author = capsule.cached_user
      assets = capsule.cached_assets
      recipients = capsule.cached_recipients
      {
        id: capsule.id,
        creator: {
          id: author.id,
          email: author.email,
          username: author.username,
          full_name: author.full_name,
          first_name: author.first_name,
          last_name: author.last_name,
          phone_number: author.phone_number,
          location: author.location,
          locale: author.locale,
          timezone: author.time_zone,
          provider: author.provider,
          uid: author.uid,
          profile_image: author.profile_image
        },
        title: capsule.title,
        hash_tags: capsule.hash_tags.split(' '),
        location: capsule.location,
        relative_location: capsule.relative_location,
        payload_type: capsule.payload_type || 0,
        status: capsule.status,
        promotional_state: capsule.promotional_state || 0,
        thumbnail: capsule.thumbnail,
        assets: [],
        start_date: '2014-04-02T11:12:13',
        lock_question: capsule.lock_question,
        lock_answer: capsule.lock_answer,
        recipients: recipients.map do |recipient|
          {
            id: recipient.id,
            email: recipient.email,
            username: recipient.username,
            full_name: recipient.full_name,
            first_name: recipient.first_name,
            last_name: recipient.last_name,
            phone_number: recipient.phone_number,
            location: recipient.location,
            locale: recipient.locale,
            timezone: recipient.time_zone,
            provider: recipient.provider,
            uid: recipient.uid,
            profile_image: recipient.profile_image,
            recipient_token: recipient.recipient_token
          }
        end,
        is_incognito: capsule.incognito || false,
        created_at: capsule.created_at,
        updated_at: capsule.updated_at
      }
    end
  end

  def purged_title
    title.slice(/^[^#]*\b/)
  end

  def thumbnail
    "http://res.cloudinary.com/demo/image/upload/w_320,h_313,c_thumb,g_face/butterfly.jpg"
  end

  def recipients_attributes=(recipients)
    @recipients_attributes = recipients
  end

  def add_as_recipient(recipient)
    recipients << recipient unless is_a_recipient?(recipient)
  end

  def is_a_recipient?(recipient)
    recipients.exists?(recipient)
  end

  def read_by?(user)
    read_by.exists?(user)
  end

  def watched_by?(user)
    watchers.exists?(user)
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

  def flush_cache
    Rails.cache.delete([self.class.name, "author"])
    Rails.cache.delete([self.class.name, "recipeints"])
    Rails.cache.delete([self.class.name, "assets"])
  end

  def cached_user
    Rails.cache.fetch([self, "author"]) { user }
  end

  def cached_recipients
    Rails.cache.fetch([self, "recipients"]) { recipients.to_a }
  end

  def cached_assets
    Rails.cache.fetch([self, "assets"]) { assets.to_a }
  end

  protected

end
