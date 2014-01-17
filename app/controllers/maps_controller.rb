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
    options = {
                x: params[:x].to_i,
                y: params[:y].to_i,
                width: params[:width].to_i,
                height: params[:height].to_i
              }
    if current_user.admin?
      view = @level.action :admin_view, options
    else
      if player_id = @level.find_player(current_user.id)
        view = @level.player_action player_id, :view, options
      else
        render json: "no player found", status: 403
      end
    end
    render json: view
  end

  # data to setup game client
  def init
    authorize! :init, @level
    if current_user.admin?
      init_info = @level.action :init_map
    else
      if player_id = @level.find_player(current_user.id)
        init_info = @level.player_action player_id, :init_map
      else
        render json: "no player found", status: 403
      end
    end
    render json: init_info.to_json
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
        redirect_to admin_levels_path
      else
        redirect_to levels_path
      end
    end
  end

end
