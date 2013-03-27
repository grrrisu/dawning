require 'spec_helper'

describe Admin::LevelsController do

  before :each do
    user = FactoryGirl.create(:admin_user)
    controller.auto_login(user)
  end

  it "should repond with success" do
    get :index
    response.should be_success
  end

end
