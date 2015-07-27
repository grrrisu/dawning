class Game.Stage

  constructor: (element_id) ->
    @resolution = window.devicePixelRatio;
    @element    = document.getElementById(element_id);
    @stage      = new PIXI.Container();
    @renderer   = PIXI.autoDetectRenderer(
      @element.width,
      @element.height,
      view: @element,
      resolution: @resolution,
      antialias: true
    );
    @renderer.backgroundColor = 0x454545;
    @map = new Game.Map @stage,
            width: @element.width / @resolution
            height: @element.height / @resolution
            fieldSize: 55

  update: () =>
    @renderer.render(@stage);
    # called 60 times per sec / 60 FPS (FramePerSeconds)
    requestAnimationFrame(@update);

  create: () =>
    @map.create();
