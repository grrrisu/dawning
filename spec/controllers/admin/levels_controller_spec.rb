require 'spec_helper'

describe Admin::LevelsController do

  before :each do
    user = create(:admin_user)
    controller.auto_login(user)
  end

  it "should repond with success" do
    get :index
    expect(response).to be_success
  end

end
