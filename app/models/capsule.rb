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
#  watchers          :integer          default([]), is an Array
#  readers           :integer          default([]), is an Array
#  creator           :hstore
#  likes             :integer          default([]), is an Array
#  tenant_id         :integer
#

class Capsule < ActiveRecord::Base
  include CapsuleCachedAssociations

  attr_reader :recipients_attributes

  before_save CapsuleCallbacks
  after_save CapsuleCallbacks
  after_create CapsuleCallbacks
  before_create CapsuleCallbacks

  validates_each :recipients_attributes, allow_blank: true do |record, attr, value|
    value.each do |recipient|
      if recipient[:email].blank? && recipient[:phone_number].blank?
        record.errors.add attr, "Recipient key is missing"
      else
        unless recipient[:email].blank?
          record.errors.add attr, 'Recipient email address is invalid' unless recipient[:email] =~ User::VALID_EMAIL_REGEX
        end
      end
    end
  end

  belongs_to :user, touch: true
  belongs_to :tenant
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, -> { where('TRIM(status) IS NULL').order(created_at: :asc) }, as: :commentable, dependent: :destroy
  has_many :assets, as: :assetable, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :recipients, through: :recipient_users, source: :user
  has_many :replies, -> { where 'TRIM(status) IS NULL' }, class_name: "Capsule", foreign_key: "in_reply_to"
  belongs_to :replied_to, -> { where 'TRIM(status) IS NULL' }, class_name: "Capsule", foreign_key: "in_reply_to", touch: true
  has_many :objections, as: :objectionable, dependent: :destroy

  delegate :full_name, to: :user, prefix: true

  accepts_nested_attributes_for :comments, allow_destroy: true
  accepts_nested_attributes_for :assets, allow_destroy: true
  accepts_nested_attributes_for :recipients

  PAYLOAD_TYPES = [NO_VALUE_TYPE = 'NoValue', AUDIO_TYPE = 'Audio', VIDEO_TYPE = 'Video', PICTURE_TYPE = 'Picture', TEXT_TYPE = 'Text']
  PROMOTIONAL_STATES = ["NoValue", "Promo State One", "Promo State Two", "Promo State Three", "Promo State Four"]
  BOX_RANGE = 0.1

  # Capsule scopes

  default_scope -> { where(tenant_id: Tenant.current_id) }

  scope :by_updated_at, -> { order(updated_at: :desc) }
  scope :hidden, -> { where(incognito: true) }
  scope :not_hidden, -> { where(incognito: false) }
  scope :absolute_location, -> { where(relative_location: nil) }
  scope :public_capsules, -> { joins('LEFT OUTER JOIN recipient_users r ON r.capsule_id = capsules.id').where('r.id IS NULL') }
  scope :without_objections, -> { where('TRIM(status) IS NULL') }

  def self.relative_location(tutorial_level = 0, user_id = nil)
    where(longitude: nil, latitude: nil).where("(relative_location -> 'tutorial_level')::int = #{tutorial_level}").public_with_user(user_id)
  end

  def self.find_in_rec(origin, span)
    east_bound = origin[:long] + span[:long]
    south_bound = origin[:lat] - span[:lat]
    where(longitude: (origin[:long]..east_bound), latitude: (south_bound..origin[:lat])).without_objections
  end

  def self.find_from_center(origin, span)
    west_bound = origin[:long] - span[:long]
    east_bound = origin[:long] + span[:long]
    north_bound = origin[:lat] + span[:lat]
    south_bound = origin[:lat] - span[:lat]
    where(longitude: (west_bound..east_bound), latitude: (south_bound..north_bound)).without_objections
  end

  def self.with_hash_tag(tag)
    where('hash_tags ilike ?', "%#{tag}%").without_objections
  end

  def self.public_with_user(user_id)
    joins('LEFT OUTER JOIN recipient_users r ON r.capsule_id = capsules.id').where('r.id IS NULL OR r.user_id = ?', user_id).without_objections
  end

  def self.find_location_hash_tags(origin, span, tag = nil)
    capsules = find_in_rec(origin, span)
    capsules = capsules.with_hash_tag(tag) if tag
    capsules.includes(:user, :assets, :recipients)
  end

  def self.find_hidden_in_rec(origin, span)
    find_in_rec(origin, span).hidden.includes(:user, :assets, :recipients)
  end

  def self.find_hashtags(origin, span, hashtag)
    start_lat = truncate_decimals(origin[:lat].to_f - span[:lat].to_f)
    end_lat = truncate_decimals(origin[:lat].to_f) + 0.1
    start_long = truncate_decimals(origin[:long].to_f) - 0.1
    end_long = truncate_decimals(origin[:long].to_f + span[:long].to_f)

    sql = <<-SQL
      SELECT regexp_matches(hash_tags, '[^[:space:]]*#{hashtag}[^[:space:]]*') as tag_match, count(*) AS tag_count
      FROM capsules
      WHERE (trunc(latitude,1) BETWEEN #{start_lat} AND #{end_lat}) AND (trunc(longitude,1) BETWEEN #{start_long} AND #{end_long}) AND (hash_tags like '%#{hashtag}%')
            AND (TRIM(status) IS NULL) AND tenant_id = #{Tenant.current_id}
      GROUP BY tag_match
      ORDER BY tag_count DESC;
    SQL

    tags = find_by_sql sql
    tags.collect { |tag| tag.tag_match.join(' ') } + promoted_tags
  end

  def self.search_capsules(query, user = nil)
    capsules = where('title ilike ?', "%#{query}%").not_hidden.absolute_location
    if user
      capsules.public_with_user(user.id)
    else
      capsules.public_capsules
    end
  end

  def self.search_hashtags(hashtag)
    with_hash_tag(hashtag)
      .not_hidden
      .absolute_location
      .select("id, regexp_matches(hash_tags, '[^[:space:]]*#{hashtag}[^[:space:]]*') as hash_tags, latitude, longitude").order(hash_tags: :desc)
  end

  def self.capsules(user_id)
    capsules = find_by_sql json_capsule_sql(user_id) { "WHERE TRIM(status) IS NULL AND user_id = #{user_id} AND tenant_id = #{Tenant.current_id}" }
  end

  def self.watched_capsules(user_id, tenant_id = Tenant.current_id)
    find_by_sql json_capsule_sql(user_id) { "WHERE TRIM(status) IS NULL AND watchers @> ARRAY[#{user_id}] AND tenant_id = #{tenant_id} ORDER BY updated_at DESC" }
  end

  def purged_title
    title.slice(/^[^#]*\b/)
  end

  def thumbnail_path
    unless self.thumbnail.blank?
      if self.thumbnail.include?('/')
        "https://#{ENV['CDN_HOST']}/#{self.thumbnail}"
      else
        "https://#{ENV['CDN_HOST']}/default/waiting-001.png"
      end
    else
      "https://#{ENV['CDN_HOST']}/default/waiting-001.png"
#     "http://res.cloudinary.com/demo/image/upload/w_320,h_313,c_thumb,g_face/butterfly.jpg"
    end
  end

  def recipients_attributes=(recipients)
    @recipients_attributes = recipients
  end

  def add_as_recipient(recipient)
    recipients << recipient unless is_a_recipient?(recipient)
  end

  def is_a_recipient?(recipient)
    recipients.include?(recipient)
  end

  def is_public?
    recipients.empty?
  end

  def read_by?(user)
    if user
      readers.include?(user.id)
    else
      false
    end
  end

  def watched_by?(user)
    if user
      watchers.include?(user.id)
    else
      false
    end
  end

  def is_processed?
    processed_flag = true
    cached_assets.each { |asset| processed_flag = false if asset.complete == false }
    processed_flag
  end

  def hash_tags_array
    self.hash_tags.split(' ') unless hash_tags.blank?
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

  def like(user)
    update_attributes(likes: likes + [user.id]) unless liked_by?(user)
    user.touch
  end

  def unlike(user)
    update_attributes(likes: likes - [user.id])
    user.touch
  end

  def is_incognito=(value)
    self.incognito = value
  end

  def is_incognito
    self.incognito
  end

  def watch(user)
    update_attributes(watchers: watchers + [user.id]) unless watched_by?(user)
    user.touch
  end

  def unwatch(user)
    update_attributes(watchers: watchers - [user.id])
    user.touch
  end

  def read(user)
    update_attributes(readers: readers + [user.id]) unless read_by?(user)
    user.touch
  end

  def unread(user)
    update_attributes(readers: readers - [user.id])
    user.touch
  end

  private

    def self.truncate_decimals(value, places = 1)
      precision = 10**places
      (value * precision).to_i / precision.to_f
    end

    def self.promoted_tags
      [ '#hometown', '#dallas', '#fishboy' ]
    end

    def self.json_capsule_sql(user_id)
      sql = <<-SQL
        SELECT row_to_json(c) AS capsule_json
        FROM (
          SELECT id, user_id, title, string_to_array(hash_tags, ' ') as hash_tags, location, relative_location, concat('https://#{ENV['CDN_HOST']}/',thumbnail) AS thumbnail,
                 lock_answer, incognito AS is_incognito, COALESCE(is_portable, 'false') AS is_portable, comments_count, coalesce(array_length(likes,1),0) AS likes_count, created_at, updated_at,
                 (
                   SELECT row_to_json(u)
                   FROM (
                     SELECT id, first_name, last_name, concat('https://#{ENV['CDN_HOST']}/',profile_image) AS profile_image
                     FROM users
                     WHERE id = capsules.user_id
                   ) u
                 ) AS creator, capsules.user_id = #{user_id} AS is_owned, #{user_id} = ANY(watchers) AS is_watched, #{user_id} = ANY(readers) AS is_read
          FROM capsules
          #{yield}
        ) c;
      SQL

      sql
    end

end
