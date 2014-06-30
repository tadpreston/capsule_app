# == Schema Information
#
# Table name: objections
#
#  id                 :integer          not null, primary key
#  objectionable_id   :integer
#  objectionable_type :string(255)
#  user_id            :integer
#  comment            :text
#  dmca               :boolean
#  criminal           :boolean
#  admin_user_id      :integer
#  handled_at         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  obscene            :boolean
#

require 'spec_helper'

describe Objection do
  before { @objection = FactoryGirl.build(:objection) }

  subject { @objection }

  it { should belong_to(:objectionable) }
  it { should belong_to(:user) }
  it { should belong_to(:admin_user) }

  describe 'setter and getters' do

    describe 'is_dmca' do
      it 'sets the dmca column' do
        @objection.is_dmca = true
        expect(@objection.dmca).to be_true
        @objection.is_dmca = false
        expect(@objection.dmca).to be_false
      end

      it 'returns the dmca column' do
        @objection.dmca = true
        expect(@objection.is_dmca).to be_true
        @objection.dmca = false
        expect(@objection.is_dmca).to be_false
      end
    end

    describe 'is_criminal' do
      it 'sets the criminal column' do
        @objection.is_criminal = true
        expect(@objection.criminal).to be_true
        @objection.is_criminal = false
        expect(@objection.criminal).to be_false
      end

      it 'returns the criminal column' do
        @objection.criminal = true
        expect(@objection.is_criminal).to be_true
        @objection.criminal = false
        expect(@objection.is_criminal).to be_false
      end
    end

    describe 'is_obscene' do
      it 'sets the obscene column' do
        @objection.is_obscene = true
        expect(@objection.obscene).to be_true
        @objection.is_obscene = false
        expect(@objection.obscene).to be_false
      end

      it 'returns the obscene column' do
        @objection.obscene = true
        expect(@objection.is_obscene).to be_true
        @objection.obscene = false
        expect(@objection.is_obscene).to be_false
      end
    end
  end
end
