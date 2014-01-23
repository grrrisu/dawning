require "spec_helper"

describe "enter level" do

  before :each do
    user = create :user, password: 'secret'
    login_with(user, 'secret')
  end

  let!(:level) { running_level }

  it "user joins a level and enters it" do
    visit '/levels'

    within("#level_#{level.id}") do
      expect(page).to have_content('players: 0')
      click_link "join_#{level.id}"
    end

    within("#level_#{level.id}") do
      expect(page).to have_content('players: 1')
      click_link "enter_#{level.id}"
    end

    expect(page).to have_content('Map')
    expect(page).to have_selector('#pawns')
  end

end
