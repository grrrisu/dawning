import { Dawning } from './namespace';

Dawning.Pawn = class Pawn {

  constructor(map){
    this.map = map;
    this.game = map.game;
    this.padding = 30;
  }

  preload(){
    this.game.load.atlasJSONHash('pawn', '/images/dungeon/walk.png', '/images/dungeon/walk.json');
  }

  createMan(x, y, dataX, dataY, pawn_id) {
    this.man = this.game.add.isoSprite(x + this.padding, y + this.padding, 0, 'pawn', 'standing_right@2x.png', this.map.isoGroup);
    this.man.anchor.set(0.5);
    this.man.resolution = 2;
    this.man.scale.set(0.5);

    this.man.animations.add('standing_down', ['standing_down@2x.png'], 0, false, false);
    this.man.animations.add('standing_left', ['standing_left@2x.png'], 0, false, false);
    this.man.animations.add('standing_right', ['standing_right@2x.png'], 0, false, false);
    this.man.animations.add('standing_up', ['standing_up@2x.png'], 0, false, false);
    this.man.animations.add('walk_down', [4,5,6,7,8,9,5], 8, true, true);
    this.man.animations.add('walk_left', [10,11,12,13,14,15,11], 8, true, true);
    this.man.animations.add('walk_right', [16,17,18,19,20,21,17], 8, true, true);
    this.man.animations.add('walk_up', [22,23,24,25,26,27,23], 8, true, true);
    this.man.animations.add('waving', ['waving_1@2x.png','waving_2@2x.png','waving_3@2x.png','waving_2@2x.png','waving_3@2x.png','waving_2@2x.png','waving_3@2x.png','waving_2@2x.png','waving_1@2x.png','standing_right@2x.png'], 3, false, false);

    this.position  = {x: dataX, y: dataY};
    this.pawn_id = pawn_id;

    this.wave();
    //this.game.time.events.add(2000, this.wave, this);

    this.game.physics.isoArcade.enable(this.man);
    this.man.enableBody = true;
    this.man.body.collideWorldBounds = true;

    this.game.camera.follow(this.man);
    this.visibleArea(dataX, dataY);
    return this;
  }

  move(x, y){
    this.map.mapData.getField(this.position.x, this.position.y).pawn = null;
    this.position = {x: x, y: y};
    this.map.mapData.getField(x,y).pawn = this;
    this.map.dawning.websocket.trigger('pawn_moved', {pawn_id: this.pawn_id, position: this.position});
  }

  wave(){
    this.man.animations.play('waving');
  }

  update(){
  }

  visibleArea(pawnX, pawnY) {
    this.map.visability.setAllInvisible();
    this.map.mapData.rayCast({x: pawnX, y: pawnY}, 5, (x, y) => {
      if(!this.map.visability.isVisible(x, y)){
        this.map.visability.setVisible(x, y, true);
      }
    });
    this.lookBehindObstacles(pawnX, pawnY);
    this.map.visability.lowlightPreviousVisibles();
  }

  lookBehindObstacles(x, y){
    this.map.mapData.eachField((field) => {
      field.obstacles.forEach((obstacle) => {
        if(obstacle.alpha < 1.0){
          this.game.add.tween(obstacle).to({alpha: 1.0}, 500, Phaser.Easing.Quadratic.InOut, true);
        }
      });
    });
    this.map.visability.lookBehindField(x, y + 1);
    this.map.visability.lookBehindField(x + 1, y + 1);
    this.map.visability.lookBehindField(x + 1, y);
  }

}
