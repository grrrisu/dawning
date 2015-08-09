require "spec_helper"

describe "map" do
  include_context "session"
  include_context "level"

  let!(:level) { running_level }
  let!(:user)  { logged_in_user }

  it "user sees map" do
    user_joined_level(user, level)
    visit level_map_path(level.id)
    expect(page).to have_selector('#map')
  end

  it "admin sees map" do
    logged_in_admin
    visit admin_launch_panel_path
    click_link 'Enter'
    expect(page).to have_selector('#map')
  end

end
