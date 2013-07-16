require "spec_helper"

describe "Home" do

  it "should display a welcome message" do
    visit '/'
    expect(page).to have_content('Welcome')
  end

end
