# == Schema Information
#
# Table name: capsules
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  title             :string(255)
#  hash_tags         :string(255)
#  location          :hstore
#  status            :string(255)
#  payload_type      :string(255)
#  promotional_state :string(255)
#  passcode          :string(255)
#  visibility        :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'spec_helper'

describe Capsule do
  before { @capsule = FactoryGirl.build(:capsule) }

  subject { @capsule }

  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }

  describe 'before_save callback' do
    describe 'with has_tags in the title' do
      it 'pulls hash tags out of the title and stores them in the has_tags field' do
        @capsule.save
        expect(@capsule.hash_tags).to_not be_blank
        @capsule.hash_tags.split(' ').each do |tag|
          expect(@capsule.title).to include(tag)
        end
      end
    end

    describe 'without hash tags in the title' do
      it 'hash_tags field should be blank' do
        @capsule.title = 'A title with no hash tags'
        @capsule.save
        expect(@capsule.hash_tags).to be_blank
      end
    end
  end

  describe 'purged_title method' do
    it 'returns the title with no hash tags' do
      @capsule.title = "A title with hash tags #hashtagone #hashtagtwo"
      @capsule.save
      expect(@capsule.purged_title).to eq('A title with hash tags')
    end
  end

end
