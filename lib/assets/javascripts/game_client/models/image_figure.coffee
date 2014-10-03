class Game.ImageFigure extends Game.Figure

  constructor: (data) ->
    @presenter        = new Game.ImagePresenter(this)
    @image            = @setImage(data)
    super(data)

  getPresenter: () =>
    @presenter

  setImage: (data) =>
    client.images[data]
