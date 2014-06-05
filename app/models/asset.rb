# == Schema Information
#
# Table name: assets
#
#  id               :integer          not null, primary key
#  capsule_id       :integer
#  media_type       :string(255)
#  resource         :string(255)
#  metadata         :hstore
#  created_at       :datetime
#  updated_at       :datetime
#  job_id           :string(255)
#  storage_path     :string(255)
#  process_response :hstore
#  complete         :boolean          default(FALSE)
#

class Asset < ActiveRecord::Base
  after_create AssetCallbacks

  belongs_to :capsule, touch: true

  validates :media_type, presence: true
  validates :resource, presence: true

  def resource_path
    "https://#{ENV['CDN_HOST']}/#{resource}"
  end

  def thumbnail
    "https://#{ENV['CDN_HOST']}/#{storage_path}/thumb/#{resource}"
  end

  def original
    "https://#{ENV['CDN_HOST']}/#{storage_path}/original/#{resource}"
  end
end
