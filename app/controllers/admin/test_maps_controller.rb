class Admin::TestMapsController < ApplicationController
  navigation :admin, :test_map

  def show
    authorize! :show, 'TestMap'
    render 'maps/show'
  end

end
