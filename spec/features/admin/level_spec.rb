require "spec_helper"

describe "Level" do
  include_context "session"

  let(:admin_page) { Levels::AdminPage.new }

  before :each do
    logged_in_admin
  end

  it "should create a new level", js: true do
    admin_page.open
    click_on 'create_level_button'
    fill_in 'level_name', with: 'level test'
    click_on 'Launch'
    select "test.yml", from: 'config_file'
    click_on 'Build'
    click_on 'Run'
    click_on 'Stop'
    click_on 'Remove'
  end

end
