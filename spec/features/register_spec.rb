require "spec_helper"

describe "Register" do

  it "a new member" do
    visit '/'
    click_link 'register'

    page.should have_content('Register')
    within('#new_user') do
      fill_in 'user_username', with: 'Rocky'
      fill_in 'user_password', with: 'Balboa'
      fill_in 'user_password_confirmation', with: 'Balboa'
      fill_in 'user_email', with: 'rocky.balboa@example.com'
      click_button 'register'
    end

    within('.alert-success') do
      page.should have_content('Successfully registered as Rocky')
    end

    ActionMailer::Base.deliveries.should have(1).item
    link = ActionMailer::Base.deliveries.first.body.match /http:\/\/.*?(\/.*?)$/
    visit link[1]
    within('.alert-success') do
      page.should have_content('User Rocky was successfully activated.')
    end
    page.should have_content('Logout')

  end

end
