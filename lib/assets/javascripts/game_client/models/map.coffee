class @Map

  constructor: () ->
    @presenter  = new MapPresenter(this)
    @fields     = []

  setFieldWidth: (width) =>
    @fieldWidth = width

  setWorldSize: (size) =>
    @worldWidth   = size.width
    @worldHeight  = size.height

  mapWidth: =>
    @width = @worldWidth * @fieldWidth

  mapHeight: =>
    @height = @worldHeight * @fieldWidth

  fetch: (request_data, callback) =>
    client.api.post '/view', request_data, (data, status, xhr) ->
      callback(data)

  render: (layer) =>
    @presenter.setLayer(layer)
    @presenter.render_fog()

  render_fields: (rx, ry, width, height) =>
    request_data = {x: rx, y: ry, width: width, height: height};
    @fetch request_data, (data) =>
      while (@fields.length > 0)
        @fields.pop().remove()

      data.each (row, j) =>
        row.each (field_data, i) =>
          field = @presenter.render_field(field_data, (rx + i) , (ry + j))
          @fields.push(field) if field?

          if field_data.flora?
            @flora  = new Banana(field_data.flora)
            @flora.setPosition(rx + i , ry + j)
            @flora.render(@presenter.layer)

      @presenter.layer.draw()


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
