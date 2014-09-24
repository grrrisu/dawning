require "spec_helper"

feature "login" do

  let!(:rocky) { create :user, username: 'Rocky', password: 'Balboa' }
  let(:login_page) { Sessions::LoginPage.new }

  scenario "as member" do
    login_page.open
    login_page.login_as 'Rocky', 'Balboa'
    expect(login_page.flash).to have_css('.alert-success')

    login_page.click_nav_logout
    expect(login_page.flash).to have_css('.alert-success')
  end

  scenario "with wrong password" do
    login_page.open
    login_page.login_as 'Rambo', 'Balboa'
    expect(login_page).to have_css('.alert-danger')
  end

end
