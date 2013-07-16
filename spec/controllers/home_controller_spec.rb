require 'spec_helper'

describe HomeController do

  it "should repond with success" do
    get :index
    expect(response).to be_success
  end

end
