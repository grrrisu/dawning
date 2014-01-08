class @Figure

  constructor: (data) ->
    if data.x? && data.y?
      @setPosition(data.x, data.y)

  render: (layer) =>
    @getPresenter().render(layer)

  setPosition: (rx, ry) ->
    @rx        = rx
    @ry        = ry
    apos = client.map.absolutePosition(@rx, @ry)
    @ax        = apos.x
    @ay        = apos.y
