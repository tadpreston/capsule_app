# == Schema Information
#
# Table name: tenant_keys
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe TenantKey do
# it { should belong_to(:tenant) }
end
