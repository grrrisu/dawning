require "spec_helper"

describe "LevelPanel" do
  include_context "session"

  let(:admin_page) { Levels::AdminPage.new }

  before :each do
    logged_in_admin
  end

  it "should create a new level" do
    admin_page.open
    click_on 'create_level_button'
    fill_in 'level[name]', with: 'level test'
    click_on 'Launch'
    admin_page.open # reopen page otherwise this test only runs with selenium
    expect(find('.levels')).to have_content('level test')
    select "test.yml", from: 'config_file'
    click_on 'Build'
    click_on 'Run'
    click_on 'Stop'
    click_on 'Remove'
  end

end
