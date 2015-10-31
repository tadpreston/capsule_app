# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  remote_ip       :string(255)
#  user_agent      :string(255)
#  auth_token      :string(255)
#  auth_expires_at :datetime
#  last_sign_in_at :datetime
#  session         :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Device do
  before do
    allow(UserCallbacks).to receive :before_save
    allow(UserCallbacks).to receive :before_validation
    allow(UserCallbacks).to receive :after_create
    allow(UserCallbacks).to receive :after_save
  end

  let!(:device_object) { FactoryGirl.create(:device) }
  subject(:device) { device_object }

  it { should respond_to(:user_id) }
  it { should respond_to(:remote_ip) }
  it { should respond_to(:user_agent) }
  it { should respond_to(:auth_token) }
  it { should respond_to(:auth_expires_at) }
  it { should respond_to(:last_sign_in_at) }
  it { should respond_to(:session) }

  it { should belong_to(:user) }

  describe 'before_create callback' do
    it 'generates an authentication token' do
      device.save
      expect(device.auth_token).to_not be_blank
    end
  end

  describe 'reset_auth_token!' do
    it 'generates a new authentication token' do
      device.save
      orig_auth_token = device.auth_token
      device.reset_auth_token!
      expect(device.auth_token).to_not eq(orig_auth_token)
    end
  end

  describe 'current_device' do
    it 'returns the right device' do
      device = FactoryGirl.create(:device, remote_ip: '192.1.2.3', user_agent: 'iPhone')
      user = device.user
      expect(user.devices.current_device('192.1.2.3', 'iPhone')).to eq(device)
    end
  end

  describe 'expire_auth_token!' do
    it 'sets auth_token to nil' do
      expect(device.auth_token).to_not be_blank
      device.expire_auth_token!
      expect(device.auth_token).to be_nil
    end
  end
end
