require 'spec_helper'

describe UsersController do

  it "should list all users" do
    get :index
    response.should be_success
    response.should render_template('index')
  end

  it "should show user" do
    get :show, id: create(:user).id
    response.should be_success
    response.should render_template('show')
  end

  it "should present register form" do
    get :new
    response.should be_success
    response.should render_template('new')
  end

  it "should rerender register form" do
    post :create, :user => {:username => 'foo'}
    response.should be_success
    response.should render_template('new')
  end

  it "should create new user" do
    user = attributes_for(:user)
    post :create, user: user
    response.should redirect_to(root_path)
  end

  it "should not accept params without password" do
    post :create, user: {:username=>"Alibaba", :email=>"Alibaba@example.com"}
    response.should be_success
    response.should render_template('new')
  end

  it "should accept params without password" do
    user = create(:user)
    controller.auto_login(user)
    put :update, id: user.id, user: {:username=>"Alibaba", :email=>"Alibaba@example.com"}
    response.should redirect_to(user_path(user))
  end

end
