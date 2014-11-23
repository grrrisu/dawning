class Admin::LaunchPanelsController < ApplicationController
  navigation :admin, :launch_panel

  def show
    authorize! :show, 'LaunchPanel'
  end

end
