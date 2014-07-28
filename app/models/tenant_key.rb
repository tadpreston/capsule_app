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

class TenantKey < ActiveRecord::Base
  before_create :generate_token

  belongs_to :tenant

  private

    def generate_token
      begin
        self.token = SecureRandom.urlsafe_base64(64)
      end while TenantKey.exists?(token: self.token)
    end
end
