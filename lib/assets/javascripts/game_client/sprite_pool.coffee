class Game.SpritePool

  constructor: (images) ->
    @sprites = {}
    images.each (image) =>
      @sprites[image] = []

  createSprite: (image) =>
    texture = PIXI.Texture.fromImage(image);
    sprite = new PIXI.Sprite(texture);
    sprite.anchor.set(0.5);
    return sprite;

  getSprite: (image) =>
    if @sprites[image].length == 0
      @createSprite(image);
    else
      return @sprites[image].shift();

  returnSprite: (sprite, image) =>
    @sprites[image].push(sprite);
