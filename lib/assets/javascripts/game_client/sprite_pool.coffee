class Game.SpritePool

  constructor: (images) ->
    @sprites = {}
    images.each (image) =>
      @sprites[image] = []

  createSprite: (image) =>
    texture = PIXI.Texture.fromImage(image);
    return new PIXI.Sprite(texture);

  getSprite: (image) =>
    if @sprites[image].length == 0
      @createSprite(image);
    else
      return @sprites[image].shift();

  returnSprite: (sprite, image) =>
    @sprites[image].push(sprite);