# == Schema Information
#
# Table name: contact_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  contact_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ContactUser do
  it { should belong_to(:user) }
  it { should belong_to(:contact) }
end
