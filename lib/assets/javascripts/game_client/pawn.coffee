class Game.Pawn

  constructor: (data, map) ->
    @id = data.id;
    @x  = data.x;
    @y  = data.y;
    @type = data.type;
    @view_radius = data.view_radius;
    @map = map;
    @sprite = @initSprite();

  initSprite: () =>
    @sprite = Game.main.assets.getPawnSprite(@type);
    @sprite.interactive = true;
    @sprite.buttonMode = true;

    @sprite
      # events for drag start
      .on('mousedown', @onDragStart)
      .on('touchstart', @onDragStart)
      # events for drag end
      .on('mouseup', @onDragEnd)
      .on('mouseupoutside', @onDragEnd)
      .on('touchend', @onDragEnd)
      .on('touchendoutside', @onDragEnd)
      # events for drag move
      .on('mousemove', @onDragMove)
      .on('touchmove', @onDragMove);

    Game.main.assets.pawns.setPawn(@id, @sprite);

  onDragStart: (event) =>
    @dragging = true;
    @startPosition = {x: @sprite.position.x, y: @sprite.position.y};
    @map.drag_handler.setDragable(false);
    @map.lowlight_around(@x, @y, @view_radius);
    @sprite.alpha = 0.7;
    @sprite.scale.set(1.5);

  onDragMove: (event) =>
    if @dragging
      newPosition = event.data.getLocalPosition(@sprite.parent);
      fieldSize = @map.fieldSize;
      dx = Math.abs(@startPosition.x - newPosition.x)
      dy = Math.abs(@startPosition.y - newPosition.y)
      restrictedPosition = @map.restrictToRadius(dx, dy, @view_radius * fieldSize, fieldSize)
      if newPosition.x >= @startPosition.x
        @sprite.position.x = @startPosition.x + restrictedPosition.dx;
      else
        @sprite.position.x = @startPosition.x - restrictedPosition.dx;
      if newPosition.y >= @startPosition.y
        @sprite.position.y = @startPosition.y + restrictedPosition.dy;
      else
        @sprite.position.y = @startPosition.y - restrictedPosition.dy;

  onDragEnd: (event) =>
    @map.drag_handler.setDragable(true);
    @map.reset_lowlight();
    @map.mapLayer.fieldClickHandler.hideBorder();
    @sprite.alpha = 1.0;
    @sprite.scale.set(1);
    @dragging = false;
    newPosition = @snapToGrid(@sprite.position.x, @sprite.position.y);
    @sprite.position.set(newPosition.ax, newPosition.ay);
    Game.main.mapController.move({pawn_id: @id, x: newPosition.rx, y: newPosition.ry});

  movementReceived: (rx, ry) =>
    x = [@x, rx].min();
    y = [@y, ry].min();
    width = [@x, rx].max() - x + 1;
    height = [@y, ry].max() - y + 1;
    Game.main.mapController.update_view({
      x: x - @view_radius,
      y: y - @view_radius,
      width: width + 2 * @view_radius,
      height: height + 2 * @view_radius
    })
    @setPosition(rx, ry);

  setPosition: (rx, ry) =>
    @x = rx;
    @y = ry;
    fieldSize = @map.fieldSize;
    @sprite.position.set(@x * fieldSize, @y * fieldSize);

  snapToGrid: (ax, ay) =>
    fieldSize = @map.fieldSize;
    rx = Math.round(ax / fieldSize);
    ry = Math.round(ay / fieldSize);
    ax = rx * fieldSize;
    ay = ry * fieldSize;
    return {ax: ax, ay: ay, rx: rx, ry: ry};
