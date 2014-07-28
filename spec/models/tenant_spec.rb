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
#  it { should have_many(:api_keys) }
#
#  describe 'generate_api_key method' do
#    it 'creates an api_key record' do
#      tenant = Tenant.create(name: 'Test Tenant')
#      expect {
#        tenant.generate_api_key('iOS')
#      }.to change(ApiKey, :count).by(1)
#    end
#  end
end
