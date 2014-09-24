require "spec_helper"

feature "Home" do

  let(:home_page) { ApplicationPage.new }

  scenario "should display a welcome message" do
    home_page.open
    expect(page).to have_content('Welcome')
  end

end
