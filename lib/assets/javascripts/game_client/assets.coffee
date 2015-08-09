class Game.Assets

  constructor: () ->
    # preload also the background images, when Pixi loads Texture.fromImage
    # it first looks in the cache before loading from the file system
    @assets = {
      "vegetation_0": "/images/map/0_desert@2x.png",
      "vegetation_1": "/images/map/1_grass@2x.png",
      "vegetation_2": "/images/map/2_grass@2x.png",
      "vegetation_3": "/images/map/3_grass@2x.png",
      "vegetation_5": "/images/map/5_grass@2x.png",
      "vegetation_8": "/images/map/8_forest@2x.png",
      "vegetation_13": "/images/map/13_forest@2x.png",

      "banana_1": "/images/map/banana-1@2x.png",
      "banana_2": "/images/map/banana-2@2x.png",
      "banana_3": "/images/map/banana-3@2x.png",

      "rabbit": "/images/map/rabbit@2x.png",
      "gazelle": "/images/map/gazelle@2x.png",
      "mammoth": "/images/map/meat@2x.png",
      "hyena": "/images/map/hyena@2x.png",
      "leopard": "/images/map/leopard@2x.png",

      "headquarter": "/images/map/Raratonga_Mask.gif",
      "base": "/images/map/caveman.png"
    }
    images = Object.values(@assets);
    @pool = new Game.SpritePool(images);
    @pawns = new Game.PawnPool();

  load: (callback) =>
    loader = PIXI.loader
    Object.each @assets, (name, image) =>
      loader.add(name, image);
    loader.load (loader, resources) ->
      callback();

  getVegetationSprite: (type) =>
    @getSprite("vegetation_#{type}");

  getFloraSprite: (type) =>
    @getSprite(type);

  getFaunaSprite: (type) =>
    @getSprite(type);

  getPawnSprite: (type, id) =>
    if id?
      pawn = @pawns.getPawn(id)
      return pawn if pawn?

    sprite = @getSprite(type);
    sprite.anchor.set(0.5);
    return sprite;

  returnSprite: (sprite) =>
    if sprite.interactive == false
      image = sprite.texture.baseTexture.imageUrl;
      if image?
        @pool.returnSprite(image, sprite);

  # private

  getSprite: (type) =>
    image = @assets[type]
    if image?
      @pool.getSprite(image);
    else
      console.log("ERROR: unkown type: #{type}");
