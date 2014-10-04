class Game.Figure

  render: (layer) =>
    @getPresenter().render(layer)

  setPosition: (rx, ry) ->
    @rx        = rx
    @ry        = ry
    apos = client.map.absolutePosition(@rx, @ry)
    @ax        = apos.x
    @ay        = apos.y

  getImage: (data) =>
    client.images[data]
