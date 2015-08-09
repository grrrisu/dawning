class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level

  # setup html for map
  def show
    authorize! :show, @level
  end

private

  def get_running_level
    if @level =  LevelProxy.find(params[:level_id])
      if current_user.admin?
        raise Exception, "level #{params[:level_id]} is not yet build" if @level.state == :launched
      else
        raise Exception, "level #{params[:level_id]} is not running" unless @level.state == :running
      end
    else
      if current_user.admin?
        redirect_to admin_launch_panel_path
      else
        redirect_to levels_path
      end
    end
  end

end
