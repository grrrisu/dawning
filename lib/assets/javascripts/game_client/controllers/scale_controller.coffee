class Game.ScaleController

  constructor: (@map) ->
    @scale = 1.0
    @bindEvents();

  bindEvents: () =>
    $('#zoom-in').on('click', @zoomInAnim);
    $('#zoom-out').on('click', @zoomOutAnim);

  zoomOut: () =>
    @zoom(@scale - 0.1);

  zoomIn: () =>
    @zoom(@scale + 0.1);

  zoom: (scale) =>
    @scale = scale;
    @map.zoom(@scale);

  zoomInAnim: () =>
    @animZoom(-0.01, 10);

  zoomOutAnim: () =>
    @animZoom(0.01, 10);

  animZoom: (step, counter) =>
    if counter > 0
      @zoom(@scale - step)
      window.setTimeout(@animZoom, 50, step, counter - 1)
