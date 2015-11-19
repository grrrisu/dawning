class DungeonsController < ApplicationController
  navigation :dungeon

  # FIXME
  skip_authorization_check

  def show
    #authorize! :show, @level
  end

end
