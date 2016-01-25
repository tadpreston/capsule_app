# == Schema Information
#
# Table name: admin_users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  auth_token      :string(255)
#

require 'spec_helper'

describe AdminUser do
  it { should have_many(:objections) }

  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:password) }
end
