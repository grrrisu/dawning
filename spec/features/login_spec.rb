require "spec_helper"

feature "login" do

  let!(:rocky) { create :user, username: 'Rocky', password: 'Balboa' }
  let(:login_page) { LoginPage.new }

  scenario "as member" do
    login_page.open
    login_page.login_as 'Rocky', 'Balboa'
    expect(login_page).to have_success_alert('Welcome back Rocky')

    login_page.logout
    expect(login_page).to have_success_alert('Goodbye Rocky')
  end

  scenario "with wrong password" do
    login_page.open
    login_page.login_as 'Rambo', 'Balboa'
    expect(login_page).to have_error_alert('Login failed')
  end

end
