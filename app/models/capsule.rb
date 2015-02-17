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
  has_many :notifications
  has_many :unlocks

  delegate :full_name, to: :user, prefix: true

  accepts_nested_attributes_for :comments, allow_destroy: true
  accepts_nested_attributes_for :assets, allow_destroy: true
  accepts_nested_attributes_for :recipients

  scope :by_updated_at, -> { order(updated_at: :desc) }

  def self.by_user user_id
    where user_id: user_id
  end

  def self.for_user user_id
    joins('LEFT OUTER JOIN recipient_users r ON r.capsule_id = capsules.id').where('r.user_id = ?', user_id)
  end

  def self.feed user_id
    union_scope(by_user(user_id), for_user(user_id))
  end

  def recipients_attributes=(recipients)
    @recipients_attributes = recipients
  end

  def add_as_recipient(recipient)
    recipients << recipient unless is_a_recipient?(recipient)
  end

  def read_by? user
    readers.exists? user
  end

  def read user
    readers << user
  end

  def unlock user_id
    unlocks.create user_id: user_id
  end

  def is_unlocked? user_id
    unlocks.exists? user_id: user_id
  end

  def thumbnail_path
    return nil if thumbnail.blank? or !thumbnail.include? '/'
    thumbnail
  end

  private

  private_class_method def self.union_scope *scopes
    id_column = "#{table_name}.id"
    sub_query = scopes.map { |s| s.select(id_column).to_sql }.join(" UNION ")
    where "#{id_column} IN (#{sub_query})"
  end

  def is_a_recipient?(recipient)
    recipients.include?(recipient)
  end
end
