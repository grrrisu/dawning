require 'spec_helper'

describe HomeController do

  it "should repond with success" do
    get :index
    response.should be_success
  end

end
