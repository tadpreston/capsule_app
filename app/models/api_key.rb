# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  tenant_id  :integer
#  name       :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class APIKey < ActiveRecord::Base
  belongs_to :tenant
end
