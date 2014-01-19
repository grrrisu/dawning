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
    render json: level_action(current_user.admin? ? :admin_view : :view, options)
  end

  # data to setup game client
  def init
    authorize! :init, @level
    render json: level_action(:init_map)
  end

  def move
    authorize! :move, @level
    render json: level_action(:move, id: params[:id], x: params[:x].to_i, y: params[:y].to_i)
  end

private

  def level_action action, params = nil
    if current_user.admin?
      @level.action action, params
    else
      @level.player_action @player_id, action, params
    end
  end

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
