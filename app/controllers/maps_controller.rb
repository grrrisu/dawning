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
    render json: { world:
      {
        width: 50, #settings.world.width,
        height: 100, #settings.world.height
      }#,
      # headquarter:
      # {
      #   x: 50, #hq.x,
      #   y: 50, #hq.y,
      #   id: 'abc123', #hq.id,
      #   pawns:
      #   [
      #     #{id: hq.pawns[0].id, type: 'base', x: hq.pawns[0].x, y: hq.pawns[0].y},
      #     #{id: hq.pawns[1].id, type: 'base', x: hq.pawns[1].x, y: hq.pawns[1].y}
      #   ]
      # }
    }.to_json
  end

private

  def get_running_level
    @level =  LevelProxy.find params[:id]
    if current_user.admin?
      raise Exception, "level #{params[:id]} is not yet build" if @level.state == :launched
    else
      raise Exception, "level #{params[:id]} is not running" unless @level.state == :running
    end
  end

end
