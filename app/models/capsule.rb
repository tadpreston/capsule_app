class Capsule < ActiveRecord::Base
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

  private

  private_class_method def self.union_scope *scopes
    id_column = "#{table_name}.id"
    sub_query = scopes.map { |s| s.select(id_column).to_sql }.join(" UNION ")
    where "#{id_column} IN (#{sub_query})"
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
