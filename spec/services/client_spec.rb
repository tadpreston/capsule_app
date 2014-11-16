require 'spec_helper'

describe Client do
  let(:device_token) { 'ABC123DEF456' }

  subject(:client) { Client.new device_token }

  describe '.initialize' do
    it 'raises an error if device_token is blank' do
      expect { Client.new '' }.to raise_error ArgumentError, 'Device token cannot be blank'
    end
  end

  describe '.push' do
    before do
      expect_any_instance_of(Urbanairship::Client).to receive(:register_device)
      expect_any_instance_of(Urbanairship::Client).to receive(:push)
    end

    it 'calls register_device' do
      subject.push 'test message'
    end

    it 'calls push' do
      subject.push 'test message'
    end
  end
end
