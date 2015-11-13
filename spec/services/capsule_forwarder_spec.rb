require 'spec_helper'

describe CapsuleForwarder do
  before do
    allow(UserCallbacks).to receive(:after_create)
  end

  let!(:forwarder) { FactoryGirl.create :user }
  let!(:asset_object) { FactoryGirl.create :asset }
  let!(:campaign_object) { FactoryGirl.create :campaign }
  let!(:capsule_object) { FactoryGirl.create :capsule, assets: [asset_object], campaign_id: campaign_object.id }
  let!(:user) { FactoryGirl.create :user, phone_number: '1234567890', email: 'test@email.com', full_name: 'Clark Kent' }
  let(:recipients) {
      [
        {
          phone_number: user.phone_number,
          email: user.email,
          full_name: user.full_name
        },
        {
          phone_number: '9876543210',
          email: 'test1@email.com',
          full_name: 'Lois Lane'
        }
      ]
  }
  let(:params) {
    {
      id: capsule_object.id,
      user_id: forwarder.id,
      recipients: recipients,
    }
  }
  let(:base_url) { 'http://someurl.com' }

  before do
    allow(capsule_object).to receive(:base_url).and_return base_url
  end

  describe '.forward' do
    subject(:capsule_forwarder) { CapsuleForwarder.forward params }
    it 'returns a capsule_forwarder object' do
      expect(capsule_forwarder).to be_a CapsuleForwarder
    end
    it 'returns a dup capsule of the registered users' do
      expect(capsule_forwarder.capsules.first).to be_a Capsule
    end
    it 'returns the same number of capsules as recipients' do
      expect(capsule_forwarder.capsules.size).to eq recipients.size
    end
    it 'has a specific comment' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.comment).to eq CapsuleForwarder::FORWARD_COMMENT }
    end
    it 'has the forwarder as the author' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.user).to eq forwarder }
    end
    it 'copies the assets' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.assets).to_not be_empty }
    end
    it 'has the correct asset' do
      expect(capsule_forwarder.capsules.first.assets.first.resource).to eq CapsuleForwarder::FORWARD_IMAGE
    end
    it 'sets forwarded to true' do
      allow(Capsule).to receive(:find).and_return capsule_object
      capsule_forwarder
      expect(capsule_object).to be_forwarded
    end
    context 'if there are unregistered recipients' do
      it 'returns the recipient with a link' do
        expect(capsule_forwarder.links.size).to eq 1
      end
      it 'creates an array of ForwardLink' do
        expect(capsule_forwarder.links.first).to be_a ForwardLink
      end
    end
    context 'if one of the recipients has already participated' do
      before { CapsuleForward.create user_id: user.id }
      it 'raises a CapsuleForwardError' do
        expect { capsule_forwarder }.to raise_error CapsuleForwardError
      end
    end
    context 'the capsule has already been forwarded' do
      it 'raises a CapsuleAlreadyForwardedError' do
        capsule_object.forwarded = true
        allow(Capsule).to receive(:find).and_return capsule_object
        expect { capsule_forwarder }.to raise_error CapsuleAlreadyForwardedError
      end
    end
  end
end
