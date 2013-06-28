require 'spec_helper'

describe User do

  it "factory should create a valid user" do
    user = create :user
    user.should_not be_new_record
  end

  it "should refuse a too short password" do
    user = User.new username: 'foo', password: 'foo', password_confirmation: 'foo', email: 'foo@bar.com'
    user.should_not be_valid
  end

  it "create with have a username, password and email" do
    User.new(username: 'foo', password: 'foo123', password_confirmation: 'foo123', email: 'foo@bar.com').should be_valid
    User.new(password: 'foo123', password_confirmation: 'foo123', email: 'foo@bar.com').should_not be_valid
    User.new(username: 'foo', email: 'foo@bar.com').should_not be_valid
    User.new(username: 'foo', password: 'foo123', password_confirmation: 'foo123').should_not be_valid
  end

  it "can remove email if notificaiton is removed as well" do
    user = create :user
    user.update_attributes(email: '', notification: false).should be_true
  end

end
