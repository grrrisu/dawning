class Admin::MonitorsController < ApplicationController
  navigation :admin, :monitor

  def show
    authorize! :show, nil
  end

end
