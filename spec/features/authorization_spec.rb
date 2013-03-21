require "spec_helper"

describe "Authorization" do

  it "a guest should have access" do
    visit '/'
    page.should have_content('Welcome')
  end

  it "a guest should not have access" do
    user = FactoryGirl.create :user
    visit edit_user_path(user)
    page.should have_content("Please login first")
  end

  it "a member should have access" do
    user = FactoryGirl.create :user, password: 'secret'
    login_with(user, 'secret')
    click_link 'Account'
    page.should have_content(user.username)
  end
  #
  # it "an admin should have access" do
  #   pending
  # end


end
