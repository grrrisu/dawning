class Game.Map

  constructor: () ->
    @presenter  = new Game.MapPresenter(this)
    @shapes     = []

  setFieldWidth: (width) =>
    @fieldWidth = width

  setWorldSize: (size) =>
    @worldWidth   = size.width
    @worldHeight  = size.height

  mapWidth: =>
    @width = @worldWidth * @fieldWidth

  mapHeight: =>
    @height = @worldHeight * @fieldWidth

  remove_shapes: =>
    while (@shapes.length > 0)
      @shapes.pop().remove()

  add_shape: (shape) =>
    @shapes.push(shape) if shape?

  # called by client on own render
  render: (map_layer, pawn_layer) =>
    @presenter.setLayer(map_layer)
    @presenter.setPawnLayer(pawn_layer)
    @presenter.render_fog()

  # called by viewport when moving map
  update_fields: (rx, ry, width, height) =>
    request_data = {x: rx, y: ry, width: width, height: height};
    client.mapController.view(request_data)

  # called by dispatcher with answer of view action
  render_fields: (data) =>
    @remove_shapes()

    data.view.each (row, j) =>
      row.each (field_data, i) =>
        if field_data?
          @render_field(field_data, data.x + i , data.y + j)

    @presenter.layer.draw()
    @presenter.pawn_layer.draw()

  render_field: (field_data, rx , ry) =>
    field_shape = @presenter.render_field(field_data, rx , ry)
    @add_shape(field_shape)

    if field_data.flora?
      @render_figure(new Game.Banana(field_data.flora), rx , ry)

    if field_data.fauna?
      @render_figure(new Game.Animal(field_data.fauna), rx , ry)

    if field_data.pawn?
      @render_pawn(field_data.pawn, rx , ry)

  render_figure: (figure, rx, ry) =>
    figure.setPosition(rx, ry)
    shape = figure.render(@presenter.layer)
    @add_shape(shape)

  # TODO
  render_pawn: (data, rx, ry) =>
    if data == 'headquarter'
      shape = client.headquarter.render(@presenter.pawn_layer)
    else if data == 'pawn'
      pawn = client.headquarter.findPawnByPosition(rx, ry)
      if pawn?
        shape = pawn.render(@presenter.pawn_layer)
      else
        console.log("ERROR pawn not found with position ["+rx+","+ry+"]")

    @add_shape(shape)


  # --- position helpers ---

  # this.field = function(x, y){
  #   var x_dimension = this.fields[0].length;
  #   var y_dimension = this.fields.length;
  #   if(x < 0) x = x_dimension + x;
  #   if(y < 0) y = y_dimension + y;
  #   if(x >= x_dimension) x = x - x_dimension;
  #   if(y >= y_dimension) y = y - y_dimension;
  #   return this.getField(x,y);
  # };

  relativePosition: (ax, ay) =>
    rx = ((ax - @fieldWidth / 2) / @fieldWidth).round()
    ry = ((ay - @fieldWidth / 2) / @fieldWidth).round()
    {x: rx, y: ry}

  absolutePosition: (rx, ry) =>
    ax = rx * @fieldWidth + (@fieldWidth / 2)
    ay = ry * @fieldWidth + (@fieldWidth / 2)
    {x: ax, y: ay}

  snapToGrid: (ax, ay) =>
    position = @relativePosition(ax, ay)
    @absolutePosition(position.x, position.y)
