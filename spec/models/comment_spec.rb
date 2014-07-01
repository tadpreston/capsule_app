# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  body             :text
#  likes_store      :hstore
#  comments_count   :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#  status           :string(255)
#

require 'spec_helper'

describe Comment do
  before { @comment = FactoryGirl.build(:comment) }

  subject { @comment }

  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should have_many(:replies) }
end
