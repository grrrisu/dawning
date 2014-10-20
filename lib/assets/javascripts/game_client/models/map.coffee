class Game.Map

  constructor: (@fieldWidth, @visibleFields) ->
    @map_presenter    = new Game.MapPresenter(this)
    @field_presenter  = new Game.FieldPresenter(this)
    @shapes           = []

  setWorldSize: (size) =>
    @worldWidth   = size.width
    @worldHeight  = size.height
    @initFields()

  initFields: =>
    @fields       = new Array(@visibleFields + 1)
    for field, index in @fields
      @fields[index] = new Array(@visibleFields + 1)

  mapWidth: =>
    @width = @worldWidth * @fieldWidth

  mapHeight: =>
    @height = @worldHeight * @fieldWidth

  layer: =>
    @map_presenter.layer

  pawn_layer: =>
    @map_presenter.pawn_layer

  remove_shapes: =>
    @fields.each (row) ->
      row.each (field) ->
        field.remove_shapes()

  # called by client on own render
  render: (map_layer, pawn_layer) =>
    @map_presenter.setLayer(map_layer)
    @map_presenter.setPawnLayer(pawn_layer)
    @map_presenter.render_fog()

  # called by dispatcher with answer of view action
  render_fields: (data) =>
    @remove_shapes()

    data.view.each (row, j) =>
      row.each (field_data, i) =>
        if field_data?
          field = @fields[i][j] = new Game.Field(field_data)
          field.render(this)

    @layer().draw()
    @pawn_layer().draw()

  # --- position helpers ---

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
