require "spec_helper"

describe "map" do

  let!(:level) { running_level }
  let!(:user) { logged_in_user }

  it "user sees map", driver: :selenium do
    user_joined_level(user, level)
    visit level_map_path(level.id)
    expect(page).to have_selector('#pawns canvas')
  end

end
