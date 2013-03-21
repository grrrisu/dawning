require "spec_helper"

describe "Home" do
  
  it "should display a welcome message" do
    visit '/'
    page.should have_content('Welcome')
  end
  
end