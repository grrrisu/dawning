class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level

  # setup html for map
  def show
    authorize! :show, @level
  end

end
