require 'spec_helper'

describe OauthsController do

  describe "GET 'oauth'" do
    it "call provider for authorization" do
      controller.stub(:login_at).and_raise('Ignore: no view for this action')
      expect(controller).to receive(:login_at).with('github')
      expect { get 'oauth', provider: 'github'}.to raise_error('Ignore: no view for this action')
    end
  end

  describe "GET 'callback'" do
    it "creates a new user" do
      controller.stub(:login_from).with('github').and_return(nil) # no authentication
      user = User.new(username: 'RockyII', name: 'Rocky Balboa')
      controller.stub(:create_from).with('github').and_return(user)

      get 'callback', provider: 'github', code: '1234567890'
      expect(response).to redirect_to(edit_user_path(user))
      expect(controller.current_user).to eq(user)
      expect(user.reload.activation_state).to eq('active')
    end

    it "logs in a known user" do
      user = create :user
      create :authentication, provider: 'github', user: user
      controller.stub(:login_from).with('github').and_return(user)

      get 'callback', provider: 'github', code: '1234567890'
      expect(response).to redirect_to(levels_path)
      expect(controller.current_user).to eq(user)
    end
  end

end
