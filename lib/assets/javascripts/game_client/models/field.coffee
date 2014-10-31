class Game.Field

  constructor: (@data) ->
    @shapes = []

  setData: (data) =>
    @data = data

  add_shape: (shape) =>
    @shapes.push(shape) if shape?

  remove_shapes: =>
    while (@shapes.length > 0)
      @shapes.pop().remove()

  render: (map) =>
    @remove_shapes()
    field_shape = map.field_presenter.render(@data)
    @add_shape(field_shape)

    if @data.flora?
      @render_figure(@data.flora.type, map)

    if @data.fauna?
      @render_figure(@data.fauna.type, map)

    if @data.pawn?
      @render_pawn(@data.pawn, map)

  render_figure: (figure_data, map) =>
    figure = new Game.Thing(figure_data)
    figure.setPosition(@data.x, @data.y)
    shape = figure.render(map.layer())
    figure.presenter.show_field_info(shape, map)
    @add_shape(shape)

  render_pawn: (data, map) =>
    pawn = client.headquarter.headquarterOrPawn(@data.x, @data.y) if client.headquarter?
    if pawn?
      shape = pawn.render(map.pawn_layer())
      @add_shape(shape)
    else
      @render_figure(data, map)
