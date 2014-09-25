# == Schema Information
#
# Table name: assets
#
#  id               :integer          not null, primary key
#  media_type       :string(255)
#  resource         :string(255)
#  metadata         :hstore
#  created_at       :datetime
#  updated_at       :datetime
#  job_id           :string(255)
#  storage_path     :string(255)
#  process_response :hstore
#  complete         :boolean          default(FALSE)
#  assetable_id     :integer
#  assetable_type   :string(255)
#

class Asset < ActiveRecord::Base
  after_create AssetCallbacks

  belongs_to :assetable, polymorphic: true, touch: true

  validates :media_type, presence: true
  validates :resource, presence: true

  def resource_path
    return resource if resource.includes? 'http'
    return hosted_resource_path if complete
    AssetPaths::WAITING_PATH
  end

  private

  def hosted_resource_path
    "#{AssetPaths::CDN_HOST}/#{resource}"
  end
end
