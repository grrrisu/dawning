class DungeonsController < ApplicationController
  navigation :dungeon

  before_filter :get_running_level

  # FIXME
  skip_authorization_check

  def show
    authorize! :show, @level
  end

end
