require 'spec_helper'

describe UserCallbacks do
  before { @user = FactoryGirl.build(:user) }

  describe "before_save callback" do
    it 'should trigger before_save callback with a new user' do
      UserCallbacks.should_receive(:before_save).at_least(:once)
      @user.save
    end

    it 'should trigger before_save with an existing user' do
      @user.save
      UserCallbacks.should_receive(:before_save).at_least(:once)
      @user.save
    end

    it 'downcases the email address' do
      @user.email = "TEST@EmaiL.Com"
      @user.save
      expect(@user.email).to eq("test@email.com")
    end
  end

  describe "before_validation callback" do
    it "should trigger the callback" do
      UserCallbacks.should_receive(:before_validation).at_least(:once)
      @user.save
    end

    it "should not trigger the callback" do
      @user.save
      UserCallbacks.should_not_receive(:before_validation)
      @user.save
    end
  end

  describe "after_create callback" do
    it "should trigger the callback" do
      UserCallbacks.should_receive(:after_create).at_least(:once)
      @user.save
    end

#    it "should send a confirmation email" do
#      User.any_instance.should_receive(:send_confirmation_email)
#      @user.save
#    end

    it "should not send a confirmation email" do
      @user.provider = 'contact'
      UserMailer.should_not_receive(:email_confirmation)
      @user.save
    end
  end

end
