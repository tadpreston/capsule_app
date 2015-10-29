# == Schema Information
#
# Table name: capsules
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  comment                 :text
#  hash_tags               :string(255)
#  location                :hstore
#  status                  :string(255)
#  visibility              :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  lock_question           :string(255)
#  lock_answer             :string(255)
#  latitude                :decimal(, )
#  longitude               :decimal(, )
#  payload_type            :integer
#  promotional_state       :integer
#  relative_location       :hstore
#  incognito               :boolean
#  in_reply_to             :integer
#  comments_count          :integer          default(0)
#  likes_store             :hstore
#  is_portable             :boolean
#  thumbnail               :string(255)
#  start_date              :datetime
#  watchers                :integer          default([]), is an Array
#  read_array              :integer          default([]), is an Array
#  tenant_id               :integer
#  creator                 :hstore
#  likes                   :integer          default([]), is an Array
#  access_token            :string(255)
#  access_token_created_at :datetime
#

class Capsule < ActiveRecord::Base
  attr_reader :recipients_attributes

  TOKEN_EXPIRE_DATE_TIME = 7.days.ago.utc

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
  has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy
  has_many :assets, as: :assetable, dependent: :destroy
  has_many :recipient_users, dependent: :destroy
  has_many :recipients, through: :recipient_users, source: :user
  has_many :capsule_reads, dependent: :destroy
  has_many :readers, through: :capsule_reads, source: :user
  has_many :notifications, dependent: :destroy
  has_many :unlocks, dependent: :destroy
  has_many :relevances, dependent: :destroy

  delegate :full_name, to: :user, prefix: true

  accepts_nested_attributes_for :comments, allow_destroy: true
  accepts_nested_attributes_for :assets, allow_destroy: true
  accepts_nested_attributes_for :recipients

  scope :by_updated_at, -> { order updated_at: :desc }
  scope :location, -> { where 'latitude IS NOT NULL AND longitude IS NOT NULL' }

  def self.by_user user_id
    where user_id: user_id
  end

  def self.for_user user_id
    joins('LEFT OUTER JOIN recipient_users r ON r.capsule_id = capsules.id').where('r.user_id = ?', user_id)
  end

  def self.locked
    joins('LEFT OUTER JOIN unlocks u ON u.user_id = capsules.user_id').where('u.user_id IS NULL')
  end

  def self.feed user_id
    union_scope by_user(user_id), for_user(user_id)
  end

  def recipients_attributes=recipients
    @recipients_attributes = recipients
  end

  def add_as_recipient recipient
    recipients << recipient unless recipients.exists? recipient
  end

  def read_by? user
    readers.exists? user
  end

  def read user
    readers << user
  end

  def unlock user
    unlocks.create user_id: user.id
    Relevance.update_relevance id, [user.id]
  end

  def is_unlocked? user_id
    unlocks.exists? user_id: user_id
  end

  def thumbnail_path
    return nil if thumbnail.blank? or !thumbnail.include? '/'
    thumbnail
  end

  def remove_capsule user
    if user_is_the_author user
      if has_been_read_or_unlocked?
        Relevance.remove user_id: user_id, capsule_id: id
      else
        destroy
      end
    else
      Relevance.remove user_id: user.id, capsule_id: id
    end
  end

  def token
    generate_access_token if access_token.nil? || access_token_created_at < TOKEN_EXPIRE_DATE_TIME
    access_token
  end

  private

  private_class_method def self.union_scope *scopes
    id_column = "#{table_name}.id"
    sub_query = scopes.map { |s| s.select(id_column).to_sql }.join(" UNION ")
    where "#{id_column} IN (#{sub_query})"
  end

  def generate_access_token
    token = TokenGenerator.new(object: self, column: :access_token).generate
    self.access_token = token
    self.access_token_created_at = Time.current
    save
  end

  def user_is_the_author user
    user_id == user.id
  end

  def has_been_read_or_unlocked?
    read_or_unlocked = false
    recipients.each do |recipient|
      read_or_unlocked = true if is_unlocked? recipient.id
      read_or_unlocked = true if read_by? recipient
    end
    read_or_unlocked
  end
end
