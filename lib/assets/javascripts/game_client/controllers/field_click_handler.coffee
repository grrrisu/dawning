class Game.FieldClickHandler

  constructor: (layer, listeners, map) ->
    @layer = layer;
    @map = map;
    listeners.each (layer) =>
      layer.interactive = true;
      layer.on('mousedown', @onClick);
      layer.on('touchstart', @onClick);

  onClick: (event) =>
    position = event.data.getLocalPosition(@layer.parent);
    rposition = @toRelativePosition(position.x, position.y);
    field = @map.getFieldAt(rposition.rx, rposition.ry);
    if field == @prevField
      @toggleBorder();
    else
      @moveBorder(field);
    @prevField = field
    @showFieldDetails(rposition.rx, rposition.ry);

  toRelativePosition: (ax, ay) =>
    rx = Math.round(ax / @map.fieldSize);
    ry = Math.round(ay / @map.fieldSize);
    return {rx: rx, ry: ry};

  drawBorder: () =>
    @graphics = new PIXI.Graphics();
    @graphics.lineStyle(1, 0xAAAAAA, 1);
    @graphics.drawRect(0, 0, @map.fieldSize - 1, @map.fieldSize - 1);
    @graphics.endFill();
    @hideBorder();
    return @graphics;

  moveBorder: (field) =>
    fieldSize = @map.fieldSize;
    @graphics.position.x = field.rx * fieldSize - fieldSize / 2
    @graphics.position.y = field.ry * fieldSize - fieldSize / 2
    @showBorder();

  toggleBorder: () =>
    @graphics.visible = !@graphics.visible;

  showFieldDetails: (rx, ry) =>
    table = $('#field-info');
    if @graphics.visible
      field = @map.data.getField(rx, ry);

    vegetationType = if field? then field.vegetation.type else '';
    vegetationSize = if field? then field.vegetation.size else '';
    floraType      = if field? && field.flora? then field.flora.type else '';
    floraSize      = if field? && field.flora? then field.flora.size else '';
    faunaType      = if field? && field.fauna? then field.fauna.type else '';
    faunaHealth    = if field? && field.fauna? then field.fauna.health else '';
    faunaAge       = if field? && field.fauna? then field.fauna.age else '';

    table.find('.vegetation-type').html(vegetationType);
    table.find('.vegetation-size').html(vegetationSize);
    table.find('.flora-type').html(floraType);
    table.find('.flora-size').html(floraSize);
    table.find('.fauna-type').html(faunaType);
    table.find('.fauna-health').html(faunaHealth);
    table.find('.fauna-age').html(faunaAge);

  hideBorder: () =>
    @graphics.visible = false;

  showBorder: () =>
    @graphics.visible = true;
