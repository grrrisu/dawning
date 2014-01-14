class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level

  # setup html for map
  def show
    authorize! :show, @level
  end

  # view data
  def view
    authorize! :view, @level
    view = @level.action :view,
                         x: params[:x].to_i,
                         y: params[:y].to_i,
                         width: params[:width].to_i,
                         height: params[:height].to_i
    render json: view
  end

  # data to setup game client
  def init
    authorize! :init, @level
    render json: @level.init_map.to_json
  end

private

  def get_running_level
    if @level =  LevelProxy.find(params[:id])
      if current_user.admin?
        raise Exception, "level #{params[:id]} is not yet build" if @level.state == :launched
      else
        raise Exception, "level #{params[:id]} is not running" unless @level.state == :running
      end
    else
      if current_user.admin?
        redirect_to admin_levels_path
      else
        redirect_to levels_path
      end
    end
  end

end
