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

  belongs_to :user
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
  BOX_RANGE = 0.2

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

  def self.find_boxes(origin, span)
    starting_lat = start_point(origin[:lat].to_f)
    starting_long = start_point(origin[:long].to_f)
    ending_lat = origin[:lat].to_f - span[:lat].to_f
    ending_long = origin[:long].to_f + span[:long].to_f

    current_lat = starting_lat
    results = { boxes: [] }

    begin
      current_long = starting_long
      begin
        capsule_count = Capsule.where(latitude: current_lat-BOX_RANGE..current_lat, longitude: current_long..current_long+BOX_RANGE).count
        center_lat = (current_lat - (BOX_RANGE/2)).round(4)
        center_long = (current_long + (BOX_RANGE/2)).round(4)
        name = "#{current_lat.round(2)},#{current_long.round(2)}"
        results[:boxes] << { name: name, center_lat: center_lat, center_long: center_long, count: capsule_count }
        current_long += BOX_RANGE
      end until current_long > ending_long
      current_lat -= BOX_RANGE
    end until current_lat < ending_lat

    results
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

  protected

    def self.start_point(point)
      (point.abs.round + (point.abs.modulo(1) < BOX_RANGE ? BOX_RANGE : 0)) * (point < 0 ? -1 : 1)
    end

end
