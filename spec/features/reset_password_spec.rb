require "spec_helper"

describe "Reset password" do

  before :each do
    create :user, username: 'Rocky', email: 'rocky@balboa.com'
  end

  it "through login form" do
    visit '/login'
    within('#session_password ~ p') do
      click_link 'here'
    end

    page.should have_content('Forgot Password')
    fill_in 'Email', with: 'rocky@balboa.com'
    click_button 'Send Mail'

    ActionMailer::Base.deliveries.should have(1).item
    link = ActionMailer::Base.deliveries.first.body.match /http:\/\/.*?(\/.*?)$/
    visit link[1]

    page.should have_content('Reset your Password')
    fill_in 'user_password', with: 'secret'
    fill_in 'user_password_confirmation', with: 'secret'
    click_button 'Reset Password'

    within('.alert-success') do
      page.should have_content('Password was successfully updated.')
    end

    click_link 'logout'
    click_link 'login'

    page.should have_content('Login')
    within('#new_session') do
      fill_in 'Username', with: 'Rocky'
      fill_in 'Password', with: 'secret'
      click_button 'Login'
    end

    within('.alert-success') do
      page.should have_content('Welcome back Rocky')
    end
  end

end
