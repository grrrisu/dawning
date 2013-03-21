require 'spec_helper'

describe SessionsController do
  
  it "should respond with success" do
    get :new
    response.should be_success
    response.should render_template('new')
  end

end
