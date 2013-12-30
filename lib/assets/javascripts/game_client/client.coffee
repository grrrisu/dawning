class @Client

  image_sources =
    'fog': 'assets/map/fog3.png'
    '0_desert': 'assets/map/0_desert4.png'
    '1_grass': 'assets/map/1_grass4.png'
    '2_grass': 'assets/map/2_grass4.png'
    '3_grass': 'assets/map/3_grass4.png'
    '5_grass': 'assets/map/5_grass4.png'
    '8_forest': 'assets/map/8_forest4.png'
    '13_forest': 'assets/map/13_forest4.png'
    'headquarter': 'assets/map/Raratonga_Mask.gif'
    'man': 'assets/map/caveman.png'

  constructor: (width) ->
    fieldsVisible = 11
    @api          = new ApiCaller()
    @map          = new Map(@viewport)
    @viewport     = new Viewport(width, fieldsVisible, @map)
    @presenter    = new StagePresenter(@viewport)

  fetch: (callback) =>
    @api.post '/players/0/map.json', null, (data) =>
      callback(data)

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

  render: () =>
    @preload_images image_sources, () =>
      @fetch (data) =>
        @presenter.render()
        @map.setWorldSize(data.world)
        @map.render(@presenter.map_layer)
        @headquarter  = new Headquarter(data.headquarter)
        @headquarter.render(@presenter.pawn_layer)
        @headquarter.pawns.each (pawn) =>
          pawn.render(@presenter.pawn_layer)
        @viewport.center()
