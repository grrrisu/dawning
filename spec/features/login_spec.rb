require "spec_helper"

describe "Login" do

  before :each do
    user = create :user, username: 'Rocky', password: 'Balboa'
    user.activate!
  end

  it "a member" do
    visit '/'
    click_link 'login'

    page.should have_content('Login')
    within('#new_session') do
      fill_in 'Username', with: 'Rocky'
      fill_in 'Password', with: 'Balboa'
      check 'Remember me'
      click_button 'login'
    end

    within('.alert-success') do
      page.should have_content('Welcome back Rocky')
    end

    click_link 'logout'
    within('.alert-success') do
      page.should have_content('Goodbye Rocky')
    end
  end

end
