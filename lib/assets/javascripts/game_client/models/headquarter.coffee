class @Headquarter extends Pawn

  constructor: (data) ->
    @presenter        = new ImagePresenter(this)
    @view_radius      = 2
    @influence_radius = 2
    @secure_radius    = 2
    @image            = client.images['headquarter']

    @createPawns(data)
    super(data)

  getPresenter: () =>
    @presenter

  createPawns: (data) =>
    @pawns = []
    data.pawns.each (pawn_data) =>
      @pawns.push new Human(pawn_data)
