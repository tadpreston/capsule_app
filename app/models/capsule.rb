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
#  payload_type      :string(255)
#  promotional_state :string(255)
#  passcode          :string(255)
#  visibility        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Capsule < ActiveRecord::Base
  before_save CapsuleCallbacks

  validates :title, presence: true

  belongs_to :user
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: :user

  scope :by_updated_at, -> { order(updated_at: :desc) }

  def purged_title
    title.slice(/^[^#]*\b/)
  end
end
