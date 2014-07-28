# == Schema Information
#
# Table name: tenants
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Tenant do
  it { should have_many(:tenant_keys) }

  describe 'generate_tenant_key method' do
    it 'creates an tenant_key record' do
      tenant = Tenant.create(name: 'Test Tenant')
      expect {
        tenant.generate_tenant_key('iOS')
      }.to change(TenantKey, :count).by(1)
    end
  end
end
