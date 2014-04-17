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
#

class Capsule < ActiveRecord::Base
  before_save CapsuleCallbacks

  validates :title, presence: true

  belongs_to :user
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy

  scope :by_updated_at, -> { order(updated_at: :desc) }

  accepts_nested_attributes_for :comments, allow_destroy: true

  PAYLOAD_TYPES = [NO_VALUE_TYPE = 'NoValue', AUDIO_TYPE = 'Audio', VIDEO_TYPE = 'Video', PICTURE_TYPE = 'Picture', TEXT_TYPE = 'Text']
  PROMOTIONAL_STATES = ["NoValue", "Promo State One", "Promo State Two", "Promo State Three", "Promo State Four"]

  def self.find_in_rec(origin, span)
    east_bound = Vincenty.destination(origin[:lat], origin[:long], 90, span[:lat])
    south_bound = Vincenty.destination(origin[:lat], origin[:long], 180, span[:long])
    where(longitude: (origin[:long]..east_bound[:lon]), latitude: (south_bound[:lat]..origin[:lat]))
  end

  def purged_title
    title.slice(/^[^#]*\b/)
  end
end
