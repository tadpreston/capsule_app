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
  has_many :tenant_keys, dependent: :destroy

  def generate_tenant_key(name)
    tenant_keys.create(name: name)
  end
end
