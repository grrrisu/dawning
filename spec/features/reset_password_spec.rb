require "spec_helper"

feature "Reset password" do

  let!(:user)                 { create :user, username: 'Rocky', email: 'rocky@balboa.com' }
  let(:home_page)             { ApplicationPage.new }
  let(:login_page)            { Sessions::LoginPage.new }
  let(:forgot_password_page)  { Sessions::ForgotPasswordPage.new }
  let(:reset_password_page)   { Sessions::ResetPasswordPage.new }

  scenario "through login form" do
    login_page.open
    login_page.click_forgot_password

    expect(page).to have_content('Forgot Password')
    forgot_password_page.fill_form_with email: user.email
    forgot_password_page.submit

    expect(forgot_password_page.emails_sent.size).to be == 1
    forgot_password_page.visit_link_in_email

    expect(page).to have_content('Reset your Password')
    reset_password_page.fill_form_with password: 'secret'
    reset_password_page.submit
    expect(reset_password_page.flash).to have_css('.alert-success')

    home_page.click_nav_logout
    home_page.click_nav_login

    expect(page).to have_content('Login')
    login_page.login_as 'Rocky', 'secret'

    expect(home_page.flash).to have_css('.alert-success')
  end

end
