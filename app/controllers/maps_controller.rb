class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level
  before_filter :find_player_id, except: :show

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
      view = @level.player_action @player_id, :view, options
    end
    render json: view
  end

  # data to setup game client
  def init
    authorize! :init, @level
    if current_user.admin?
      init_info = @level.action :init_map
    else
      init_info = @level.player_action @player_id, :init_map
    end
    render json: init_info
  end

  def move
    authorize! :move, @level
    result = @level.player_action @player_id, :move, id: params[:id], x: params[:x].to_i, y: params[:y].to_i
    render json: result
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

  def find_player_id
    unless current_user.admin?
      unless @player_id = @level.find_player(current_user.id)
        render json: "no player found", status: 403
      end
    end
  end

end
