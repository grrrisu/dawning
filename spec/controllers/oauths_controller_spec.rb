require 'spec_helper'

describe OauthsController do

  describe "GET 'oauth'" do
    it "call provider for authorization" do
      controller.stub!(:login_at).and_raise('Ignore: no view for this action')
      controller.should_receive(:login_at).with('github')
      lambda { 
        get 'oauth', provider: 'github'
      }.should raise_error('Ignore: no view for this action')
    end
  end
  
  describe "GET 'callback'" do
    it "creates a new user" do
      controller.stub!(:login_from).with('github').and_return(nil) # no authentication
      user = User.new(username: 'RockyII', name: 'Rocky Balboa')
      controller.stub!(:create_from).with('github').and_return(user)
      
      get 'callback', provider: 'github', code: '1234567890'
      response.should redirect_to(edit_user_path(user))
      controller.current_user.should == user
      user.reload.activation_state.should == 'active'
    end
    
    it "logs in a known user" do
      user = FactoryGirl.create :user
      FactoryGirl.create :authentication, provider: 'github', user: user
      controller.stub!(:login_from).with('github').and_return(user)
      
      get 'callback', provider: 'github', code: '1234567890'
      response.should redirect_to(root_path)
      controller.current_user.should == user
    end
  end

end
