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

  WAITING_PATH = "https://#{ENV['CDN_HOST']}/default/waiting-001.png"
  CDN_HOST = "https://#{ENV['CDN_HOST']}"

  def resource_path
    if resource =~ /http|https/
      resource
    elsif complete
       "#{CDN_HOST}/#{self.resource}"
    else
       WAITING_PATH
    end
  end

end
