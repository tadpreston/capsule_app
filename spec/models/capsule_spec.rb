# == Schema Information
#
# Table name: capsules
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  comment                 :text
#  hash_tags               :string(255)
#  location                :hstore
#  status                  :string(255)
#  visibility              :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  lock_question           :string(255)
#  lock_answer             :string(255)
#  latitude                :decimal(, )
#  longitude               :decimal(, )
#  payload_type            :integer
#  promotional_state       :integer
#  relative_location       :hstore
#  incognito               :boolean
#  in_reply_to             :integer
#  comments_count          :integer          default(0)
#  likes_store             :hstore
#  is_portable             :boolean
#  thumbnail               :string(255)
#  start_date              :datetime
#  watchers                :integer          default([]), is an Array
#  read_array              :integer          default([]), is an Array
#  tenant_id               :integer
#  creator                 :hstore
#  likes                   :integer          default([]), is an Array
#  access_token            :string(255)
#  access_token_created_at :datetime
#  campaign_id             :integer
#  forwarded               :boolean
#

require 'spec_helper'

describe Capsule do
  before do
    allow(CapsuleCallbacks).to receive :before_create
    allow(CapsuleCallbacks).to receive :before_save
    allow(CapsuleCallbacks).to receive :after_save
    allow(CapsuleCallbacks).to receive :after_create
    allow(CapsuleReadCallbacks).to receive :after_create
    allow(UserCallbacks).to receive :before_save
    allow(UserCallbacks).to receive :before_validation
    allow(UserCallbacks).to receive :after_create
    allow(UserCallbacks).to receive :after_save
  end

  let!(:capsule_object) { FactoryGirl.create :capsule }

  it { should belong_to(:user) }
  it { should belong_to(:campaign) }
  it { should have_many(:comments) }
  it { should have_many(:assets) }
  it { should have_many(:recipient_users) }
  it { should have_many(:recipients).through(:recipient_users) }
  it { should have_many(:capsule_reads) }
  it { should have_many(:readers).through(:capsule_reads) }
  it { should have_many(:notifications) }
  it { should have_many(:unlocks) }
  it { should have_many(:relevances) }

  it { should accept_nested_attributes_for(:comments).allow_destroy(true) }
  it { should accept_nested_attributes_for(:assets).allow_destroy(true) }
  it { should accept_nested_attributes_for(:recipients) }

  it { should delegate(:full_name).to(:user).with_prefix }

  describe 'recipients_attributes validation' do
    subject(:capsule) { Capsule.new recipients_attributes: recipients }

    context 'without any recipients' do
      let(:recipients) { [] }
      it 'returns a valid capsule' do
        expect(capsule).to be_valid
      end
    end
    context 'with a recipient' do
      context 'with a phone_number' do
        let(:recipients) { [{ phone_number: '9728675309', full_name: 'Bob Smith' }] }
        it 'is a valid capsule with a phone_number' do
          expect(capsule).to be_valid
        end
      end
      context 'with an email' do
        let(:recipients) { [{ email: 'test@email.com', full_name: 'Bob Smith' }] }
        it 'returns a valid capsule with a valid email' do
          expect(capsule).to be_valid
        end
      end
      context 'without an email and a phone number' do
        let(:recipients) { [{ full_name: 'Bob Smith' }] }
        it 'is not valid' do
          expect(capsule).to_not be_valid
        end
        it 'has an error message' do
          capsule.valid?
          expect(capsule.errors.messages[:recipients_attributes]).to eq(['Recipient key is missing'])
        end
      end
      context 'invalid formatted email' do
        let(:recipients) { [{ email: 'invalidemail', full_name: 'Bob Smith' }] }
        it 'is not valid' do
          expect(capsule).to_not be_valid
        end
        it 'has the correct error message' do
          capsule.valid?
          expect(capsule.errors.messages[:recipients_attributes]).to eq(['Recipient email address is invalid'])
        end
      end
    end
  end

  describe "#add_as_recipient" do
    let!(:recipient) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.add_as_recipient recipient }

    it 'adds a user as a recipient' do
      expect(capsule).to include(recipient)
    end

    context 'recipient already exists' do
      it 'does not add the recipient' do
        capsule_object.recipients << recipient
        capsule
        expect(capsule_object.recipients.size).to eq(1)
      end
    end
  end

  describe '#read_by?' do
    let!(:recipient) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.read_by? recipient }
    context 'recipient has not read the capsule' do
      it 'returns false' do
        expect(capsule).to be_false
      end
    end
    context 'the recipient is nil' do
      let(:recipient) { nil }
      it 'returns false' do
        expect(capsule).to be_false
      end
    end
    context 'recipient has read the capsule' do
      it 'returns true' do
        capsule_object.read recipient
        expect(capsule).to be_true
      end
    end
  end

  describe '#read' do
    let!(:recipient) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.read recipient }
    it 'adds to the readers' do
    expect { capsule }.to change(CapsuleRead, :count).by 1
    end
  end

  describe '#unlock' do
    let!(:user) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.unlock user }
    before { allow(Relevance).to receive(:update_relevance).with capsule_object.id, [user.id] }
    it 'adds to the unlock table' do
      expect { capsule }.to change(Unlock, :count).by 1
    end
    it 'updates the relevance' do
      capsule
      expect(Relevance).to have_received :update_relevance
    end
  end

  describe '#is_unlocked?' do
    let!(:user) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.is_unlocked? user.id }
    context 'the user has not read the capsule' do
      it 'returns false' do
        expect(capsule).to be_false
      end
    end
    context 'the user has read the capsule' do
      it 'returns true' do
        capsule_object.read user
        expect(capsule).to be_false
      end
    end
  end

  describe '#thumbnail_path' do
    subject(:capsule) { capsule_object.thumbnail_path }
    context 'the thumbnail is nil' do
      it 'returns nil' do
        expect(capsule).to be_nil
      end
    end
    context 'the thumbnail is only the file name' do
      it 'returns nil' do
        capsule_object.thumbnail = 'something.jpg'
        expect(capsule).to be_nil
      end
    end
    context 'the thumbnail is a full path' do
      let(:thumbnail) { 'full/path.jpg' }
      it 'returns the thumbnail' do
        capsule_object.thumbnail = thumbnail
        expect(capsule).to eq thumbnail
      end
    end
  end

  describe '#remove_capsule' do
    let!(:recipient) { FactoryGirl.create :user }
    subject(:capsule) { capsule_object.remove_capsule user }
    before do
      allow(Relevance).to receive(:remove).with user_id: user.id, capsule_id: capsule_object.id
      capsule_object.recipients << recipient
    end
    context 'the user is the author' do
      let(:user) { capsule_object.user }
      context 'the capsule has been read or unlocked' do
        before { capsule_object.read recipient }
        it 'calls Relevance.remove' do
          capsule
          expect(Relevance).to have_received(:remove)
        end
      end
      context 'the capsule has not been read or unlocked' do
        before { allow(capsule_object).to receive(:destroy) }
        it 'destroys the capsule' do
          capsule
          expect(capsule_object).to have_received :destroy
        end
      end
    end
    context 'the user is not the author' do
      let(:user) { recipient }
      it 'calls Relevance.remove' do
        capsule
        expect(Relevance).to have_received(:remove)
      end
    end
  end

  describe '#token' do
    let(:token) { 'hello' }
    subject(:capsule) { capsule_object.token }
    context 'the token is nil' do
      it 'generates a token' do
        expect(capsule).to_not be_nil
      end
    end
    context 'the token has expired' do
      before do
        capsule_object.access_token = token
        capsule_object.access_token_created_at = 8.days.ago
      end
      it 'generates a token' do
        expect(capsule).to_not be_nil
      end
    end
    context 'the access_token is valid' do
      before do
        capsule_object.access_token = token
        capsule_object.access_token_created_at = 1.day.ago
        allow(capsule_object).to receive(:generate_access_token)
      end
      it 'does not generate a new token' do
        capsule
        expect(capsule_object).to_not have_received(:generate_access_token)
      end
      it 'returns the existing token' do
        expect(capsule).to equal token
      end
    end
  end

  describe '#forwardable?' do
    context 'there is a campaign' do
      let(:campaign_object) { double(budget_room?: true, redeemed?: false) }
      before { allow(capsule_object).to receive(:campaign).and_return campaign_object }

      subject(:capsule) { capsule_object.forwardable? }

      context 'the capsule has not been forwarded' do
        it 'returns true' do
          expect(capsule).to be_true
        end
      end
      context 'the capsule has been forwarded' do
        before { capsule_object.forwarded = true }
        it 'returns false' do
          expect(capsule).to be_false
        end
      end
      context 'the balance is below the budget' do
        it 'returns true' do
          expect(capsule).to be_true
        end
        it 'calls Campaign.budget_room?' do
          capsule
          expect(campaign_object).to have_received :budget_room?
        end
      end
      context 'the balance is above the budget' do
        let(:campaign_object) { double(budget_room?: false, redeemed?: false) }
        it 'returns false' do
          expect(capsule).to be_false
        end
      end
    end
    context 'there is no campaign' do
      it 'returns false' do
        expect(capsule_object).to_not be_forwardable
      end
    end
  end

  describe '#redeemable' do
    context 'there is a campaign' do
      let(:redeemed) { true }
      let(:budget_room) { true }
      let(:campaign_object) { double(budget_room?: budget_room, redeemed?: redeemed) }

      before { allow(capsule_object).to receive(:campaign).and_return campaign_object }

      subject(:capsule) { capsule_object.redeemable? }

      context 'the promotion has not been redeemed' do
        let(:redeemed) { false }
        it 'returns true' do
          expect(subject).to be_true
        end
      end
      context 'the promotion has been redeemed' do
        it 'returns false' do
          expect(subject).to be_false
        end
      end
      context 'the balance is above the promotion budget' do
        let(:budget_room) { false }
        it 'returns false' do
          expect(subject).to be_false
        end
      end
    end
    context 'there is no campaign' do
      it 'returns false' do
        expect(capsule_object).to_not be_redeemable
      end
    end
  end
end
