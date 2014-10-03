class Game.Human extends Game.Pawn

  constructor: (data) ->
    @presenter        = new Game.ImagePresenter(this)
    @view_radius      = 1
    @influence_radius = 1
    @type             = data.type
    @image            = client.images['pawn']
    super(data)

  getPresenter: () =>
    @presenter
