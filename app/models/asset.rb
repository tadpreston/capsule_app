# == Schema Information
#
# Table name: assets
#
#  id         :integer          not null, primary key
#  capsule_id :integer
#  media_type :string(255)
#  resource   :string(255)
#  metadata   :hstore
#  created_at :datetime
#  updated_at :datetime
#

class Asset < ActiveRecord::Base
  belongs_to :capsule

  validates :media_type, presence: true
  validates :resource, presence: true
end
