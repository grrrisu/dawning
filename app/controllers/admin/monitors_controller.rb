class Admin::MonitorsController < ApplicationController
  layout 'monitor'
  navigation :admin, :monitor

  def show
    authorize! :show, nil
  end

end
