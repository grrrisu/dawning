class Game.CenterMapController

  constructor: (@map) ->
    @bindEvents();

  bindEvents: () =>
    $('#center_view').on('click', @center);

  center: () =>
    headquarter = Game.main.headquarter
    if headquarter?
      @map.center(headquarter.x, headquarter.y);
    return false;
