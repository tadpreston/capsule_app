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

    it "should send a confirmation email" do
      UserMailer.should_receive(:email_confirmation).and_return(double("Mailer", deliver: true))
      @user.save
    end

    it "should not send a confirmation email" do
      @user.provider = 'contact'
      UserMailer.should_not_receive(:email_confirmation)
      @user.save
    end
  end

  describe "before_update callback" do
    before { @user.save }

    it "should trigger the callback" do
      @user.email = "changed@mail.com"
      UserCallbacks.should_receive(:before_update).at_least(:once)
      @user.save
    end

    it "should not trigger the callback" do
      UserCallbacks.should_not_receive(:before_update)
      @user.save
    end

    describe "with a changed email" do
      it "should set unconfirmed_email to the new value of email" do
        @user.email = "newemail@testing.com"
        @user.save
        expect(@user.unconfirmed_email).to eq("newemail@testing.com")
      end

      it "should reset email to the previous value" do
        prev_email = @user.email
        @user.email = "newemail@testing.com"
        @user.save
        expect(@user.email).to eq(prev_email)
      end

      it "should send a confirmation email" do
        @user.email = "newemail@testing.com"
        User.any_instance.should_receive(:send_confirmation_email)
        @user.save
      end
    end

    describe "without changing the email" do
      it "should not set unconfirmed_email to the new value of email" do
        @user.save
        expect(@user.unconfirmed_email).to be_nil
      end

      it "should not send a confirmation email" do
        User.any_instance.should_not_receive(:send_confirmation_email)
        @user.save
      end
    end
  end
end
