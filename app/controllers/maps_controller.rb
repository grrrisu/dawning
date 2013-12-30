class MapsController < ApplicationController

  def show
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

end
