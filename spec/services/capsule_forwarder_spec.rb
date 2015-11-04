require 'spec_helper'

describe CapsuleForwarder do
  before do
    allow(UserCallbacks).to receive(:after_create)
  end

  let!(:forwarder) { FactoryGirl.create :user }
  let!(:asset_object) { FactoryGirl.create :asset }
  let!(:capsule_object) { FactoryGirl.create :capsule, assets: [asset_object] }
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

  describe '.forward' do
    subject(:capsule_forwarder) { CapsuleForwarder.forward params }
    it 'returns a capsule_forwarder object' do
      expect(capsule_forwarder).to be_a CapsuleForwarder
    end
    it 'returns a dup capsule of the registered users' do
      expect(capsule_forwarder.capsules.first).to be_a Capsule
    end
    it 'returns the same number of capsules as registered recipients' do
      expect(capsule_forwarder.capsules.size).to eq 1
    end
    it 'is a duplicate of the original capsule' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.comment).to eq capsule_object.comment }
    end
    it 'has the forwarder as the author' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.user).to eq forwarder }
    end
    it 'copies the assets' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule.assets).to_not be_empty }
    end
    it 'creates forwarded capsules' do
      capsule_forwarder.capsules.each { |capsule| expect(capsule).to be_forwarded }
    end
    context 'if there are unregistered recipients' do
      it 'returns the recipient with a link' do
        expect(capsule_forwarder.links.size).to eq 1
      end
    end
  end
end
