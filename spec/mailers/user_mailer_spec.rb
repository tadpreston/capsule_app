require "spec_helper"

describe UserMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user = FactoryGirl.create(:user)
  end

  after(:each) { ActionMailer::Base.deliveries.clear }

  describe "email_confirmation" do
    before { UserMailer.email_confirmation(@user).deliver }

    it "should send the email" do
      ActionMailer::Base.deliveries.count.should == 1
    end

    it 'renders the receiver email' do
      expect(ActionMailer::Base.deliveries.first.to[0]).to eq(@user.email)
    end

    it 'should set the subject to the correct subject' do
      expect(ActionMailer::Base.deliveries.first.subject).to eq('Welcome to Capsule! Please confirm your email address.')
    end

    it 'renders the sender email' do
      expect(ActionMailer::Base.deliveries.first.from).to eq(['confirm@capsuleapp.net'])
    end
  end
end
