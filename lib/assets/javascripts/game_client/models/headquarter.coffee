class Game.Headquarter extends Game.Pawn

  constructor: (data) ->
    @presenter        = new Game.DragablePresenter(this)
    @view_radius      = 2
    @influence_radius = 2
    @secure_radius    = 2
    @image            = @getImage('headquarter')
    super(data)

  getPresenter: () =>
    @presenter

  createPawns: (data) =>
    @pawns = []
    data.pawns.each (pawn_data) =>
      @pawns.push new Game.Human(pawn_data)

  findPawn: (id) =>
    @pawns.find (pawn) =>
      pawn.id == id

  findPawnByPosition: (rx, ry) =>
    @pawns.find (pawn) =>
      pawn.rx == rx && pawn.ry == ry

  headquarterOrPawn: (rx, ry) =>
    return this if @rx == rx && @ry == ry
    @findPawnByPosition(rx, ry)
