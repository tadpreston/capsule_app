# == Schema Information
#
# Table name: campaigns
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  code        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  budget      :decimal(, )
#  base_url    :string(255)
#

require 'spec_helper'

describe Campaign do
  let!(:campaign_object) { FactoryGirl.create :campaign, budget: 100.00 }

  describe 'associations' do
    it { should have_many :capsules }
    it { should have_many :campaign_transactions }
  end

  describe '#budget_room?' do
    let(:transaction1) { double :transaction, amount: amount }
    let(:transaction2) { double :transaction, amount: amount }

    subject(:campaign) { campaign_object.budget_room? }

    before { FactoryGirl.create_list :campaign_transaction, 2, campaign_id: campaign_object.id, amount: amount }

    context 'the budget is greater than the amount spent' do
      let(:amount) { 25.00 }
      it 'returns true' do
        expect(campaign).to be_true
      end
    end
    context 'the budget is equal to the amount spent' do
      let(:amount) { 50.00 }
      it 'returns false' do
        expect(campaign).to be_false
      end
    end
    context 'the budget is greater than the amount spent' do
      let(:amount) { 60.00 }
      it 'returns false' do
        expect(campaign).to be_false
      end
    end
  end

  describe '#redeemed?' do
    let(:transactions) { double :transactions, exists?: exists }
    let(:user_object) { double :user, id: 1 }

    subject(:campaign) { campaign_object.redeemed? user_object }

    before { allow(campaign_object).to receive(:campaign_transactions).and_return transactions }

    context 'the campaign was redeemed' do
      let(:exists) { true }
      it 'returns true' do
        expect(campaign).to be_true
      end
    end
    context 'the campaign is not redeemed' do
      let(:exists) { false }
      it 'returns false' do
        expect(campaign).to be_false
      end
    end
  end
end
