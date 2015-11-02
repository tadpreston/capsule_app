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
  before do
    allow(UserCallbacks).to receive(:after_create)
  end

  let!(:comment_object) { FactoryGirl.create :comment }

  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should have_many(:objections) }

  describe '#liked_by' do
    let!(:user) { FactoryGirl.create :user }
    subject(:comment) { comment_object.liked_by? user }
    before { comment_object.likes << user }
    it 'returns true' do
      expect(comment).to be_true
    end
  end
end
