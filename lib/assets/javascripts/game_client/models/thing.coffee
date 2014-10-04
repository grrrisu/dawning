class Game.Thing extends Game.Figure

  # data is 'headquarter' or 'leopard' or something like that
  constructor: (data) ->
    @presenter        = new Game.ImagePresenter(this)
    @image            = @getImage(data)

  getPresenter: () =>
    @presenter
