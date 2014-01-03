class MapsController < ApplicationController
  navigation :map

  before_filter :get_running_level

  def show
    authorize! :show, @level
    respond_to do |format|
      format.html # setup html
      format.json # send map data
    end

  end

  def create
    render json: { world:
      {
        width: 100, #settings.world.width,
        height: 300, #settings.world.height
      },
      headquarter:
      {
        x: 50, #hq.x,
        y: 50, #hq.y,
        id: 'abc123', #hq.id,
        pawns:
        [
          #{id: hq.pawns[0].id, type: 'base', x: hq.pawns[0].x, y: hq.pawns[0].y},
          #{id: hq.pawns[1].id, type: 'base', x: hq.pawns[1].x, y: hq.pawns[1].y}
        ]
      }
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
