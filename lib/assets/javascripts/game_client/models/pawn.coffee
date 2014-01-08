class @Pawn extends Figure

  constructor: (data) ->
    @id        = data.id
    @draggable = true
    super(data)

  checkBoundaries: (pos) =>
    pos

  drop: (ax, ay) =>
    apos = client.map.snapToGrid(ax, ay)
    @getPresenter().move(apos.x, apos.y)
    rpos = client.map.relativePosition(apos.x, apos.y)
    @update(rpos.x, rpos.y)

  update: (rx, ry) =>
    request_data =
      id: @id
      x: rx
      y: ry
    client.api.post '/move', request_data, (data, status, xhr) =>
      @move(data.x, data.y)
      client.viewport.update_map();

  move: (rx, ry) =>
    @rx = rx;
    @ry = ry;
    pos = client.map.absolutePosition(rx, ry);
    @ax = pos.x
    @ay = pos.y
    @getPresenter().move(@ax, @ay)
