require 'spec_helper'

describe UserCallbacks do
  let(:user) { FactoryGirl.build(:user) }
  let(:saved_user) { FactoryGirl.create(:user) }

  describe "before_save callback" do
    it 'triggers before_save callback with a new user' do
      expect(UserCallbacks).to receive(:before_save).at_least(:once)
      user.save
    end

    it 'triggers before_save with an existing user' do
      expect(UserCallbacks).to receive(:before_save).at_least(:once)
      saved_user.save
    end

    it 'downcases the email address' do
      user.email = "TEST@EmaiL.Com"
      user.save
      expect(user.email).to eq("test@email.com")
    end
  end

  describe "before_validation callback" do
    it "triggers the callback" do
      expect(UserCallbacks).to receive(:before_validation).at_least(:once)
      user.save
    end

    it "does not trigger the callback" do
      user.save
      expect(UserCallbacks).to_not receive(:before_validation)
      user.save
    end
  end

  describe "after_create callback" do
    it "triggers the callback" do
      expect(UserCallbacks).to receive(:after_create).at_least(:once)
      user.save
    end

    it "should send a confirmation email" do
      expect(user).to receive(:send_confirmation_email)
      user.save
    end

    it "should not send a confirmation email" do
      expect(UserMailer).to_not receive(:email_confirmation)
      user.provider = 'contact'
      user.save
    end
  end

end
