class @Client

  image_sources =
    'fog': 'images/fog3.png'
    '0_desert': 'images/0_desert4.png'
    '1_grass': 'images/1_grass4.png'
    '2_grass': 'images/2_grass4.png'
    '3_grass': 'images/3_grass4.png'
    '5_grass': 'images/5_grass4.png'
    '8_forest': 'images/8_forest4.png'
    '13_forest': 'images/13_forest4.png'
    'headquarter': 'images/Raratonga_Mask.gif'
    'man': 'images/caveman.png'

  constructor: (width) ->
    fieldsVisible = 11
    @api          = new ApiCaller('http://localhost:4567')
    @map          = new Map(@viewport)
    @viewport     = new Viewport(width, fieldsVisible, @map)
    @presenter    = new StagePresenter(@viewport)

  fetch: (callback) =>
    @api.post '/init', null, (data) =>
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
