require "spec_helper"

describe UserMailer do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "email_confirmation" do
    #    Commented out because not sending confirmation email out now
#    it "should send the email" do
#      expect {
#        UserMailer.email_confirmation(@user).deliver
#      }.to change(ActionMailer::Base.deliveries, :count).by(1)
#    end
#
#    it 'renders the receiver email' do
#      UserMailer.email_confirmation(@user).deliver
#      expect(ActionMailer::Base.deliveries.first.to[0]).to eq(@user.email)
#    end
#
#    it 'should set the subject to the correct subject' do
#      UserMailer.email_confirmation(@user).deliver
#      expect(ActionMailer::Base.deliveries.first.subject).to eq('Welcome to Capsule! Please confirm your email address.')
#    end
#
#    it 'renders the sender email' do
#      UserMailer.email_confirmation(@user).deliver
#      expect(ActionMailer::Base.deliveries.first.from).to eq(['confirm@capsuleapp.net'])
#    end
  end
end
