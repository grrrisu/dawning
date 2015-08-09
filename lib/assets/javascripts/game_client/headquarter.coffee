class Game.Headquarter extends Game.Pawn

  constructor: (data, map) ->
    super(data.headquarter, map);
    @pawns = @createPawns(data.headquarter.pawns, map);

  createPawns: (data, map) =>
    data.map (pawn_data) =>
      new Game.Pawn(pawn_data, map);

  getPawn: (id) =>
    return this if @id == id;
    @pawns.find (pawn) =>
      return pawn.id == id;
