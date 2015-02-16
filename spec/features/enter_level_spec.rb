require "spec_helper"

describe "enter level" do
  include_context "session"
  include_context "level"

  let!(:level)      { running_level }
  let(:level_page)  { Levels::IndexPage.new}

  before :each do
    logged_in_user
  end

  it "user joins a level and enters it" do
    level_page.open
    expect(level_page.entry(level)).to have_content('players: 0')
    level_page.join level

    expect(level_page.entry(level)).to have_content('players: 1')
    level_page.enter level

    expect(page).to have_content('Map')
    expect(page).to have_selector('#pawns')
  end

end
