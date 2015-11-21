import { Dawning } from './namespace';

Dawning.Map = class Map {

  constructor(dawning, options){
    this.dawning = dawning;
    this.game = dawning.game;
    this.size = options.size;
    this.fieldSize = options.fieldSize;
    this.halfFieldSize = this.fieldSize / 2;
    this.mapSize = this.size * this.fieldSize;
    this.mapData = new Dawning.MapData(this);
    this.pawn = new Dawning.Pawn(this);
    this.rabbitBuilder = new Dawning.Rabbit(this);
    this.inputHandler = new Dawning.InputHandler(this);
  }

  preload(){
    this.game.load.image('1_grass', 'images/1_grass@2x.png');
    this.game.load.image('2_grass', 'images/2_grass@2x.png');
    this.game.load.image('3_grass', 'images/3_grass@2x.png');
    this.game.load.image('13_forest', 'images/13_forest@2x.png');
    this.game.load.image('banana1', 'images/banana-1@2x.png');
    this.game.load.image('banana2', 'images/banana-2@2x.png');
    this.game.load.image('banana3', 'images/banana-3@2x.png');
    this.game.load.image('leopard', 'images/leopard@2x.png');

    this.mapData.createData(Dawning.Data.map3);

    this.pawn.preload();
    this.rabbitBuilder.preload();
  }

  create(){
    this.game.physics.startSystem(Phaser.Physics.P2JS);

    this.ground = this.game.add.group();

    this.forest = this.game.add.group();
    this.forest.enableBody = true;

    this.fruits = this.game.add.group();
    this.fruits.enableBody = true;

    this.predators = this.game.add.group();
    this.predators.enableBody = true;

    this.herbivors = this.game.add.group();
    this.herbivors.enableBody = true;

    this.maskGraphics = this.game.add.graphics(0, 0);
    this.man = this.pawn.createMan(12, 12);

    this.forestTop = this.game.add.group();
    this.createFields();

    //this.forest.mask = this.maskGraphics;
    //this.forestTop.mask = this.maskGraphics;
    this.ground.mask = this.maskGraphics;
    this.fruits.mask = this.maskGraphics;
    this.predators.mask = this.maskGraphics;
    this.herbivors.mask = this.maskGraphics;

    this.inputHandler.create();
  }

  createFields(){
    this.mapData.eachField((field, x, y) => {
      this.createGrass(x, y);
      if (field.wall){
        this.createTree(x, y);
      } else {
        if(field.fruit){
          this.createFruit(x, y, field.fruit);
        } else if(field.predator){
          this.createLeopard(x, y);
        } else if(field.herbivor){
          this.rabbitBuilder.createRabbit(this.herbivors, x, y);
        }
      }
    });
  }

  createTree(x, y){
    var tree = this.forest.create(x * this.fieldSize, y * this.fieldSize, 'pawn', 5);
    this.forestTop.create(x * this.fieldSize, (y-1) * this.fieldSize + 34, 'pawn', 6);
    //tree.scale.setTo(0.5);
    tree.body.immovable = true;
  }

  createGrass(x, y){
    var grass = this.ground.create(x * this.fieldSize, y * this.fieldSize, '3_grass');
    grass.scale.setTo(0.5);
  }

  createLeopard(x, y){
    var leopard = this.predators.create(x * this.fieldSize + this.halfFieldSize, y * this.fieldSize + this.halfFieldSize, 'leopard');
    leopard.anchor.set(0.5);
    leopard.scale.setTo(0.5);
  }

  createFruit(x, y, type) {
    var fruit = this.fruits.create(x * this.fieldSize, y * this.fieldSize, 'banana'+type);
    fruit.scale.setTo(0.5);
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

  update(){
    this.collisionDetection();
    this.inputHandler.moveWithCursor(this.man);
  }

  collisionDetection(){
    this.game.physics.arcade.collide(this.man.man, this.forest);

    this.game.physics.arcade.overlap(this.man.man, this.herbivors, this.rabbitBuilder.escape, null, this.rabbitBuilder);
    this.game.physics.arcade.overlap(this.man.man, this.fruits, this.dawning.collectBanana, null, this.dawning);
    this.game.physics.arcade.overlap(this.man.man, this.predators, this.dawning.attacked, null, this.dawning);
  }

  relativePosition(ax, ay){
    return {
      x: Math.round((ax - this.halfFieldSize) / this.fieldSize),
      y: Math.round((ay - this.halfFieldSize) / this.fieldSize)
    };
  }

}
