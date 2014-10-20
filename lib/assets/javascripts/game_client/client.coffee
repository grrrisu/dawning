class Game.Client

  constructor: (width) ->
    fieldsVisible = 11
    @api            = new Game.ApiCaller()
    @dispatcher     = new Game.Websocket()
    @mapController  = new Game.MapController(@dispatcher)
    @chatController = new Game.ChatController(@dispatcher)
    @map            = new Game.Map(width / fieldsVisible, fieldsVisible)
    @viewport       = new Game.Viewport(width, fieldsVisible, @map)
    @presenter      = new Game.StagePresenter(@viewport)

  preload_images: (sources, callback) =>
    @images = {};
    loadedImages = 0;
    numImages = 0;
    # get num of sources
    for src of sources
      numImages++

    for src of sources
      @images[src] = new Image()
      @images[src].onload = () =>
        callback() if ++loadedImages >= numImages
      @images[src].src = sources[src]

  start: () =>
    # variable image_sources is defined on the page, see maps/show.html
    @preload_images image_sources, () =>
      @mapController.init_map()

  render: (data) =>
    @presenter.render()
    @map.setWorldSize(data.world)
    @map.render(@presenter.map_layer, @presenter.pawn_layer)
    # admin view has no headquarter
    if data.headquarter?
      @headquarter  = new Game.Headquarter(data.headquarter)
      @headquarter.createPawns(data.headquarter)
    @viewport.center()



