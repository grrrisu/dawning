require "spec_helper"

feature "Register" do

  let(:home_page)     { ApplicationPage.new }
  let(:register_page) { Users::RegisterPage.new }
  let(:register_params) {
    {
      username: 'Rocky',
      password: 'Balboa',
      email:    'rocky.balboa@example.com'
    }
  }

  scenario "as a new member" do
    home_page.open
    home_page.click_nav_register
    expect(page).to have_content('Register')

    register_page.fill_form_with register_params
    register_page.submit

    expect(home_page.flash).to have_content('Successfully registered as Rocky')
    expect(home_page.emails_sent.size).to be == 1
    home_page.visit_link_in_email

    expect(home_page.flash).to have_content('Welcome Rocky! Your account has been activated.')
    expect(register_page.navigation).to have_content('Logout')
  end

end
