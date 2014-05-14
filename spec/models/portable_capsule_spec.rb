# == Schema Information
#
# Table name: portable_capsules
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe PortableCapsule do
  it { should belong_to(:user) }
  it { should belong_to(:capsule) }
end
