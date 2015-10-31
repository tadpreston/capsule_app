require 'spec_helper'

describe CapsuleForwarder do
  before do
    allow(UserCallbacks).to receive(:after_create)
  end

  let!(:forwarder) { FactoryGirl.create :user }
  let!(:capsule_object) { FactoryGirl.create :capsule }
  let(:recipients) {
      [
        {
          phone_number: '1234567890',
          email: 'test@email.com',
          full_name: 'Clark Kent'
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
    it 'returns a collection of capsules' do
      expect(capsule_forwarder.first).to be_a Capsule
    end
    it 'returns the same number of capsules as recipients' do
      expect(capsule_forwarder.size).to eq recipients.size
    end
    it 'is a duplicate of the original capsule' do
      capsule_forwarder.each { |capsule| expect(capsule.comment).to eq capsule_object.comment }
    end
    it 'has the forwarder as the author' do
      capsule_forwarder.each { |capsule| expect(capsule.user).to eq forwarder }
    end
  end
end
