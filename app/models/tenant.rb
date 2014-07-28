# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tenant < ActiveRecord::Base
#  has_many :api_keys
#
#  def generate_api_key(name)
#    api_keys.create(name: name)
#  end
end
