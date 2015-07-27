class Game.MapLayer

  constructor: (stage, map) ->
    @vegetation_layer = new PIXI.Container();
    @pawn_layer = new PIXI.Container();
    @click_layer = new PIXI.Container();
    @layer = new PIXI.Container();

    @fieldClickHandler = new Game.FieldClickHandler(@click_layer, [@vegetation_layer, @pawn_layer], map);

    @layer.addChild(@vegetation_layer);
    @layer.addChild(@click_layer);
    @layer.addChild(@pawn_layer);

    stage.addChild(@layer);

  init: () =>
    border = @fieldClickHandler.drawBorder();
    @click_layer.addChild(border);

  setFieldSize: (fieldSize) =>
    @fieldSize = fieldSize;


  setField: (x, y, data) =>
    field = new Game.Field(x, y);
    vegetationSprite = @setVegetation(x, y, data.vegetation, field);
    @setFlora(data.flora, vegetationSprite, field) if data.flora?;
    @setFauna(data.fauna, vegetationSprite, field) if data.fauna?;
    @setPawn(data.pawn, x, y, @pawn_layer, field) if data.pawn?;
    return field;

  setVegetation: (x, y, vegetation, field) =>
    sprite = Game.main.assets.getVegetationSprite(vegetation.type)
    sprite.position.x = x * (@fieldSize);
    sprite.position.y = y * (@fieldSize);
    @vegetation_layer.addChild(sprite);
    field.setVegetationSprite(sprite);
    return sprite;

  setFlora: (data, parent, field) =>
    sprite = Game.main.assets.getFloraSprite(data.type);
    field.setFloraSprite(sprite);
    @centerSprite(sprite);
    parent.addChild(sprite);

  setFauna: (data, parent, field) =>
    sprite = Game.main.assets.getFaunaSprite(data.type);
    field.setFaunaSprite(sprite);
    @centerSprite(sprite);
    parent.addChild(sprite);

  setPawn: (data, x, y, parent, field) =>
    sprite = Game.main.assets.getPawnSprite(data.type, data.id);
    field.setPawnSprite(sprite);
    sprite.position.x = (x + 0.5) * @fieldSize;
    sprite.position.y = (y + 0.5) * @fieldSize;
    parent.addChild(sprite);

  centerSprite: (sprite) =>
    sprite.position.x = (@fieldSize - sprite.width ) / 2;
    sprite.position.y = (@fieldSize - sprite.height ) / 2;

  mapMovedTo: (ax, ay) =>
    @ax = ax;
    @ay = ay;
    @layer.position.x = ax;
    @layer.position.y = ay;

  getPosition: () =>
    @layer.position;

  scale: (n) =>
    @layer.scale.x = n;
    @layer.scale.y = n;
