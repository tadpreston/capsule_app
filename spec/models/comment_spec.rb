# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  capsule_id :integer
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Comment do
  before { @comment = FactoryGirl.build(:comment) }

  subject { @comment }

  it { should belong_to(:user) }
  it { should belong_to(:capsule) }
end
