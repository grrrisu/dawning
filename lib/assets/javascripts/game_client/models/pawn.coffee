class Game.Pawn extends Game.Figure

  # data is {x: 2, y: 3, type: 'pawn', id: '123'}
  constructor: (data) ->
    @id        = data.id
    @setPosition(data.x, data.y)

  checkBoundaries: (pos) =>
    pos

  drop: (ax, ay) =>
    apos = client.map.snapToGrid(ax, ay)
    @getPresenter().move(apos.x, apos.y)
    rpos = client.map.relativePosition(apos.x, apos.y)
    window.client.mapController.move({pawn_id: @id, x: rpos.x, y: rpos.y})

  # invoked by dispatcher on move
  update: (data) =>
    @move(data.x, data.y)
    client.viewport.update_map()

  move: (rx, ry) =>
    @rx = rx;
    @ry = ry;
    pos = client.map.absolutePosition(rx, ry);
    @ax = pos.x
    @ay = pos.y
    @getPresenter().move(@ax, @ay)
