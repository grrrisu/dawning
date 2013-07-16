require 'spec_helper'

describe SessionsController do

  it "should respond with success" do
    get :new
    expect(response).to be_success
    expect(response).to render_template('new')
  end

end
