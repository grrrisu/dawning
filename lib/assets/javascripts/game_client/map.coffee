class Game.Map

  constructor: (stage, options) ->
    @mapLayer             = new Game.MapLayer(stage, this);
    @drag_handler         = new Game.MapDragHandler(@mapLayer.layer, this);
    @scaleController      = new Game.ScaleController(this);
    @centerMapController  = new Game.CenterMapController(this);
    @data                 = new Game.MapData();
    @fields               = [];

    @fieldSize      = options['fieldSize'] + 1; # +1 border
    @viewportWidth  = options['width'];
    @viewportHeight = options['height'];
    @scale          = 1.0;
    @setDimensions();

    @blur_filter = new PIXI.filters.BlurFilter();
    @blur_filter.blur = 15;

  setDimensions: () =>
    @fieldWidth  = Math.floor(@viewportWidth / (@fieldSize * @scale)) + 2;
    @fieldHeight = Math.floor(@viewportHeight / (@fieldSize * @scale)) + 2;
    @data.setDataDimensions(@fieldWidth, @fieldHeight);

  init: (callback) =>
    @mapLayer.init();
    Game.main.mapController.initMap();

  initDataLoaded: (initData) =>
    if initData.headquarter?
      console.log("hx #{initData.headquarter.x} hy #{initData.headquarter.y}")
      @setAndMoveToCenter(initData.headquarter.x, initData.headquarter.y)
      headquarter = new Game.Headquarter(initData, this);
    else
      @setAndMoveToCenter(initData.center.x, initData.center.y)
    Game.main.dataLoaded(headquarter);

  setAndMoveToCenter: (rx, ry) =>
    @setCenter(rx, ry);
    @moveToCenter(rx, ry);

  loadFieldData: () =>
    @data.loadData () =>

  dataReceived: (data) =>
    @data.addDataSet(data);
    @updateFields(data);

  updateFields: (fieldData) =>
    x = [fieldData.x, @data.rx].max() - @data.rx;
    y = [fieldData.y, @data.ry].max() - @data.ry;
    size = fieldData.view.length;

    if (fieldData.x + size >= @data.rx && fieldData.x < @data.rx + @fieldWidth) && (fieldData.y + size >= @data.ry && fieldData.y < @data.ry + @fieldHeight)

      width = size;
      if fieldData.x < @data.rx
        width = (fieldData.x + size) - @data.rx;
      else if fieldData.x + size > @data.rx + @fieldWidth
        width = (@data.rx + @fieldWidth) - fieldData.x

      height = size
      if fieldData.y < @data.ry
        height = (fieldData.y + size) - @data.ry;
      else if fieldData.y + size > @data.ry + @fieldHeight
        height = (@data.ry + @fieldHeight) - fieldData.y

      @removeFields(x, x + width, y, y + height);
      @createFields(x, x + width, y, y + height);

  updateMap: (data) =>
    @data.updateFields(data);
    x = data.x - @data.rx
    y = data.y - @data.ry
    @removeFields(x, x + data.view[0].length, y, y + data.view.length);
    @createFields(x, x + data.view[0].length, y, y + data.view.length);

  setCenter: (centerX, centerY) =>
    @centerX = centerX;
    @centerY = centerY;

  getCenter: () =>
    if @centerX? && @centerY
      return [@centerX, @centerY]
    else
      center = @toCenterPosition();
      @setCenter(center[0], center[1]);
      return [center[0], center[1]];

  clearCenter: () =>
    @centerX = null;
    @centerY = null;

  moveToCenter: (centerX, centerY) =>
    aposition = @centerToAbsolutePosition(centerX, centerY);
    rposition = @toRelativePosition(aposition[0], aposition[1]);
    @mapLayer.mapMovedTo(aposition[0], aposition[1]);
    @data.setDataPosition(rposition.rx, rposition.ry);

  centerToAbsolutePosition: (centerX, centerY) =>
    ax = -centerX * (@fieldSize * @scale) + @viewportWidth / 2;
    ay = -centerY * (@fieldSize * @scale) + @viewportHeight / 2;
    return[ax, ay];

  toCenterPosition: () =>
    centerX = @data.rx + Math.floor(@fieldWidth / 2);
    centerY = @data.ry + Math.floor(@fieldHeight / 2);
    return [centerX, centerY];

  toRelativePosition: (ax, ay) =>
    rx = Math.floor(-ax / (@fieldSize * @scale));
    ry = Math.floor(-ay / (@fieldSize * @scale));
    return {rx: rx, ry: ry};

  createFields: (startX, endX, startY, endY) =>
    @data.eachField startX, endX, startY, endY, (rx, ry) =>
      data = @data.getField(rx, ry);
      @createField(rx, ry, data) if data?;

  removeFields: (startX, endX, startY, endY) =>
    @data.eachField startX, endX, startY, endY, (rx, ry) =>
      @fields.remove (field) =>
        if field.rx == rx && field.ry == ry
          field.clear(@mapLayer);
          return true;

  getFieldAt: (rx, ry) =>
    @fields.find (field) ->
      return field.rx == rx && field.ry == ry

  createField: (rx, ry, data) =>
    @mapLayer.setFieldSize(@fieldSize);
    already_created = @fields.any (field) =>
      return field.rx == rx && field.ry == ry;

    unless already_created
      field = @mapLayer.setField(rx, ry, data);
      @fields.unshift(field);

  mapMovedTo: (ax, ay) =>
    @mapLayer.mapMovedTo(ax, ay);
    rposition = @toRelativePosition(ax, ay);
    @data.mapMovedTo rposition.rx, rposition.ry, (deltaX, deltaY) =>
      @clearCenter();
      if deltaX > 0 # move to the right
        @createFields(@fieldWidth - deltaX, @fieldWidth, 0, @fieldHeight);
        @removeFields(0 - deltaX, 0, 0, @fieldHeight);
      else if deltaX < 0 # move to the left
        @createFields(0, Math.abs(deltaX), 0, @fieldHeight);
        @removeFields(@fieldWidth, @fieldWidth - deltaX, 0, @fieldHeight);
      if deltaY > 0 # move down
        @createFields(0, @fieldWidth, @fieldHeight - deltaY, @fieldHeight);
        @removeFields(0, @fieldWidth, 0 - deltaY, 0);
      else if deltaY < 0 # move up
        @createFields(0, @fieldWidth, 0, Math.abs(deltaY));
        @removeFields(0, @fieldWidth, @fieldHeight, @fieldHeight - deltaY);

  withinRadius: (dx, dy, radius, border) =>
    border = 1 unless border?
    return false if dx > radius || dy > radius
    Math.pow(dx,2) + Math.pow(dy,2) <= Math.pow(radius, 2) + border;

  restrictToRadius: (dx, dy, radius, border) =>
    border = 1 unless border?
    return @restrictToRadius(radius, dy, radius, border) if dx > radius;
    return @restrictToRadius(dx, radius, radius, border) if dy > radius;
    if Math.pow(dx,2) + Math.pow(dy,2) <= Math.pow(radius, 2) + border
      return {dx: dx, dy: dy}
    else
      return @restrictToRadius(dx - 1, dy - 1, radius, border);

  lowlight_around: (rx, ry, view_radius) =>
    @fields.each (field) =>
      unless @withinRadius(field.rx - rx, field.ry - ry, view_radius, 1)
        field.lowlight();

  reset_lowlight: () =>
    @fields.each (field) =>
      field.default_light();

  zoom: (newScale) =>
    center = @getCenter();
    @scale = newScale;
    @mapLayer.scale(newScale);
    @setDimensions();
    @center(center[0], center[1]);

  center: (rx, ry) =>
    @removeFields(0, @fieldWidth, 0, @fieldHeight);
    @moveToCenter(rx, ry);
    @data.updateData();
    @createFields(0, @fieldWidth, 0, @fieldHeight);

  clearFields: () =>
    @fields.each (field) =>
      field.clear(@mapLayer);
    @fields = [];
