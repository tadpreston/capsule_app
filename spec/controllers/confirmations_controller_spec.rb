require 'spec_helper'

describe ConfirmationsController do

  describe "GET 'email'" do
    it "returns http success" do
      get 'email'
      response.should be_success
    end
  end

end
