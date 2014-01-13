require 'spec_helper'

describe LevelsController do

  before :each do
    user = create(:user)
    controller.auto_login(user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
