import { Dawning } from './namespace';

Dawning.IsoMap = class IsoMap {

  constructor(dawning, options) {
    this.dawning = dawning;
    this.game    = dawning.game;
    this.size = options.size;
    this.fieldSize = options.fieldSize;
    this.halfFieldSize = this.fieldSize / 2;
    this.mapSize = this.size * this.fieldSize;
    this.needsTopologicalSort = false;

    this.mapData = new Dawning.MapData(this);
    this.visability = new Dawning.Visability(this.mapData);
    this.rabbitBuilder = new Dawning.Rabbit(this);
    this.leopardBuilder = new Dawning.Leopard(this);
    this.pawnBuilder = new Dawning.Pawn(this);
    this.inputHandler = new Dawning.InputHandler(this);
    console.log(options);
  }

  preload() {
    this.game.plugins.add(new Phaser.Plugin.Isometric(this.game));

    this.game.world.setBounds(0, 0, this.size * this.fieldSize, this.size * this.fieldSize);

	  this.game.physics.startSystem(Phaser.Plugin.Isometric.ISOARCADE);

    this.game.iso.projectionAngle = 0.52;  // approximate value
	  // set the middle of the world in the middle of the screen
	  this.game.iso.anchor.setTo(0.5, 0);

    this.game.load.image('field', '/images/dungeon/iso_field.png');
    this.game.load.image('grass', '/images/dungeon/iso_grass.png');
    //this.game.load.image('grass', '/images/grass2.png');

    this.game.load.atlasJSONHash('tree', '/images/dungeon/trees.png', '/images/dungeon/trees.json');

    this.game.load.image('leopard', '/images/dungeon/leopard@2x.png');

    this.rabbitBuilder.preload();
    this.leopardBuilder.preload();
    this.pawnBuilder.preload();
  }

  createFromData(data){
    console.log("map data received");
    this.mapData.createData(data);
    this.create();
  }

  create() {
    this.leopardBuilder.create();

    this.floorGroup = this.game.add.group();
    this.isoGroup = this.game.add.group();

    this.game.physics.isoArcade.gravity.setTo(0, 0, -500);

    this.forest  = [];
    this.fruits = [];
    this.herbivors = [];
    this.predators = [];

    this.createFields();
    this.visability.lowlightAll();

    var pos = this.mapPosition(12, 12);
    this.man = this.pawnBuilder.createMan(pos.x, pos.y, 12, 12);
    this.inputHandler.create();
  }

  createFields(){
    this.mapData.eachField((field, x, y) => {
      var pos = this.mapPosition(x, y);
      this.createFloor(pos.x, pos.y, x, y);
      if (field.wall){
        this.createTree(pos.x, pos.y, x, y, field.wall);
      } else {
        if(field.fruit){
          this.createFruit(pos.x, pos.y, x, y, field.fruit);
        } else if(field.predator){
          this.leopardBuilder.createLeopard(pos.x, pos.y, x, y);
        } else if(field.herbivor){
          this.rabbitBuilder.createRabbit(this.herbivors, pos.x, pos.y, x, y);
        }
      }
    });
  }

  createFloor(x, y, dataX, dataY){
    var floorTile = this.game.add.isoSprite(x + 40, y + 40, 1, 'grass', 0, this.floorGroup);
    floorTile.anchor.set(0.5);

    var darkenColors = [0xffffff, 0xdddddd, 0xddffff, 0xffddff, 0xffffdd];
    var tintColor = this.game.rnd.integerInRange(0, 4);
    floorTile.tint = darkenColors[tintColor];
    floorTile.originTint = floorTile.tint;

    this.mapData.addFloor(floorTile, dataX, dataY);
  }

  createTree(x, y, dataX, dataY, type){
    var tree;
    if(type == 'X'){
      var num  = this.game.rnd.integerInRange(1, 4);
      tree = this.game.add.isoSprite(x, y, 0, 'tree', 'jungle_tree_'+num+'.png', this.isoGroup);
    } else if(type == 'x'){
      tree = this.game.add.isoSprite(x, y, 0, 'tree', 'bush_1.png', this.isoGroup);
    }
    var darkenColors = [0xffffff, 0xdddddd, 0xddffff, 0xffddff, 0xffffdd];
    var tintColor = this.game.rnd.integerInRange(0, 4);
    tree.tint = darkenColors[tintColor];
    tree.originTint = tree.tint;

    this.forest.push(tree);
    tree.anchor.set(0.5);
    this.game.physics.isoArcade.enable(tree);
    tree.body.immovable = true;
    tree.body.collideWorldBounds = true;
    tree.body.widthX = this.fieldSize;
    tree.body.widthY = this.fieldSize;
    this.mapData.addObstacle(tree, dataX, dataY);
  }

  createFruit(x, y, dataX, dataY, type) {
    let palm_type = Math.abs(type);
    let fruit = this.game.add.isoSprite(x, y, 0, 'tree', `palm_${palm_type}.png`, this.isoGroup);
    fruit.animations.add('empty', [(parseInt(palm_type) * 2 + 4)], 60, false, true);
    if(type < 0) fruit.animations.play('empty');
    this.fruits.push(fruit);
    this.game.physics.isoArcade.enable(fruit);
    fruit.body.immovable = true;
    fruit.body.collideWorldBounds = true;
    fruit.anchor.set(0.5);
    this.mapData.addThing(fruit, dataX, dataY);
  }

  mapPosition(x, y){
    return {
      x: x * this.fieldSize,
      y: y * this.fieldSize
    }
  }

  relativePosition(x, y){
    return {
      x: x / this.fieldSize,
      y: y / this.fieldSize
    }
  }

  update(){
    if(this.man) {
      this.collisionDetection();
      this.inputHandler.movePawn(this.man);
      this.topologicalSort();
      this.man.update();
    }
  }

  positionChanged(){
    this.needsTopologicalSort = true;
  }

  topologicalSort(){
    if(this.needsTopologicalSort){
      this.game.iso.topologicalSort(this.isoGroup);
      this.needsTopologicalSort = false;
    }
  }

  collisionDetection(){
    this.game.physics.isoArcade.collide(this.man.man, this.floorGroup);
    this.game.physics.isoArcade.collide(this.man.man, this.forest);
    this.predators.forEach((predator) => {
      this.game.physics.isoArcade.collide(predator, this.forest, this.leopardBuilder.colliding, null, this.leopardBuilder);
    });

    this.game.physics.isoArcade.collide(this.man.man, this.fruits, this.dawning.collectBanana, null, this.dawning);

    // this.game.physics.isoArcade.overlap(this.man.man, this.herbivors, this.rabbitBuilder.escape, null, this.rabbitBuilder);
    this.game.physics.isoArcade.overlap(this.man.man, this.predators, this.dawning.attacked, null, this.dawning);
  }

  render() {
    // this.floorGroup.forEach( (tile) => {
    //   this.game.debug.body(tile, 'rgba(189, 221, 235, 0.6)', false);
    // });
    // if (this.isoGroup){
    //   this.isoGroup.forEach( (tile) => {
    //     this.game.debug.body(tile, 'rgba(189, 221, 235, 0.6)', false);
    //   });
    // }
  }

  isWall(x, y){
    return this.mapData.isWall(x, y);
  }

  isFree(x, y){
    return this.mapData.isFree(x, y);
  }

  getField(x, y){
    return this.mapData.getField(x, y);
  }

}
