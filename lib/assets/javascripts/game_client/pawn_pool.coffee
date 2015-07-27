class Game.PawnPool

  constructor: ->
    @pawns = {};

  getPawn: (id) =>
    @pawns[id];

  setPawn: (id, sprite) =>
    @pawns[id] = sprite;
