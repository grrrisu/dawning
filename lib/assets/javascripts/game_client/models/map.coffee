class @Map

  constructor: () ->
    @presenter  = new MapPresenter(this)
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
    console.log(@shapes.length)
    while (@shapes.length > 0)
      @shapes.pop().remove()

  add_shape: (shape) =>
    @shapes.push(shape) if shape?

  fetch: (request_data, callback) =>
    client.api.post '/view', request_data, (data, status, xhr) ->
      callback(data)

  render: (layer) =>
    @presenter.setLayer(layer)
    @presenter.render_fog()

  render_fields: (rx, ry, width, height) =>
    request_data = {x: rx, y: ry, width: width, height: height};
    @fetch request_data, (data) =>
      @remove_shapes()

      data.each (row, j) =>
        row.each (field_data, i) =>
          if field_data?
            field_shape = @presenter.render_field(field_data, (rx + i) , (ry + j))
            @add_shape(field_shape)

            if field_data.flora?
              @render_figure(new Banana(field_data.flora), rx + i, ry + j)

            if field_data.fauna?
              @render_figure(new Animal(field_data.fauna), rx + i, ry + j)

            if field_data.pawn?
              @render_pawn(field_data.pawn, (rx + i), (ry + j))

      @presenter.layer.draw()

  render_figure: (figure, rx, ry) =>
    figure.setPosition(rx, ry)
    shape = figure.render(@presenter.layer)
    @add_shape(shape)

  # TODO
  render_pawn: (data, rx, ry) =>
    if data == 'headquarter'
      shape = client.headquarter.render(@presenter.layer)
    else if data == 'pawn'
      shape = client.headquarter.findPawn(rx, ry).render(@presenter.layer)

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
