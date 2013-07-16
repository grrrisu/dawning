require "spec_helper"

describe "Register" do

  it "a new member" do
    visit '/'
    click_link 'register'

    expect(page).to have_content('Register')
    within('#new_user') do
      fill_in 'user_username', with: 'Rocky'
      fill_in 'user_password', with: 'Balboa'
      fill_in 'user_password_confirmation', with: 'Balboa'
      fill_in 'user_email', with: 'rocky.balboa@example.com'
      click_button 'register'
    end

    within('.alert-success') do
      expect(page).to have_content('Successfully registered as Rocky')
    end

    expect(ActionMailer::Base.deliveries).to have(1).item
    link = ActionMailer::Base.deliveries.first.body.match /http:\/\/.*?(\/.*?)$/
    visit link[1]
    within('.alert-success') do
      expect(page).to have_content('Welcome Rocky! Your account has been activated.')
    end
    expect(page).to have_content('Logout')

  end

end
