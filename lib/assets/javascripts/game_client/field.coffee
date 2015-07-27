class Game.Field

  constructor: (@rx, @ry) ->

  clear: (mapLayer) =>
    @removeFloraSprite() if @floraSprite?;
    @removeFaunaSprite() if @faunaSprite?;
    @removePawnSprite()  if @pawnSprite?;
    @removeVegetationSprite(mapLayer);

  setVegetationSprite: (sprite) =>
    @vegetationSprite = sprite;

  removeVegetationSprite: (mapLayer) =>
    mapLayer.layer.removeChild(@vegetationSprite);
    @returnSprite(@vegetationSprite);
    @vegetationSprite = null;

  setFloraSprite: (sprite) =>
    @floraSprite = sprite;

  removeFloraSprite: () =>
    @remove_from_parent(@floraSprite);
    @floraSprite = null;

  setFaunaSprite: (sprite) =>
    @faunaSprite = sprite;

  removeFaunaSprite: () =>
    @remove_from_parent(@faunaSprite);
    @faunaSprite = null;

  setPawnSprite: (sprite) =>
    @pawnSprite = sprite;

  removePawnSprite: () =>
    @remove_from_parent(@pawnSprite);
    @pawnSprite = null;

  lowlight: () =>
    @vegetationSprite.filters = [Game.main.stage.map.blur_filter];
    #@vegetationSprite.alpha = 0.6;
    @vegetationSprite.tint = 0x888888;
    @floraSprite.tint = 0x888888 if @floraSprite?;
    @faunaSprite.tint = 0x888888 if @faunaSprite?;
    @pawnSprite.tint = 0x888888 if @pawnSprite?;

  default_light: () =>
    @vegetationSprite.filters = null;
    #@vegetationSprite.alpha = 1.0;
    @vegetationSprite.tint = 0xFFFFFF;
    @floraSprite.tint = 0xFFFFFF if @floraSprite?;
    @faunaSprite.tint = 0xFFFFFF if @faunaSprite?;
    @pawnSprite.tint = 0xFFFFFF if @pawnSprite?;

  # private

  remove_from_parent: (sprite) =>
    sprite.parent.removeChild(sprite);
    @returnSprite(sprite);

  returnSprite: (sprite) =>
    Game.main.assets.returnSprite(sprite);
