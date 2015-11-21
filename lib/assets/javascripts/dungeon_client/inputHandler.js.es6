import { Dawning } from './namespace';

Dawning.InputHandler = class InputHandler {

  constructor(map){
    this.map = map;
    this.game = map.game;
    this.currentPos = {x: null, y: null};
  }

  create(){
    this.cursors = this.game.input.keyboard.createCursorKeys();
  }

  positionChanged(pawn){
    var rpos = this.map.relativePosition(pawn.man.isoX - pawn.padding, pawn.man.isoY - pawn.padding);
    var x = Math.round(rpos.x);
    var y = Math.round(rpos.y);
    if (this.currentPos.x != x || this.currentPos.y != y){
      this.map.positionChanged();
      pawn.visibleArea(x, y);
      if(this.currentPos.x) this.map.mapData.getField(this.currentPos.x, this.currentPos.y).pawn = null;
      this.currentPos = {x: x, y: y};
      this.map.mapData.getField(x,y).pawn = pawn;

      this.map.leopardBuilder.update();
    } else if(!this.currentPos.x){
      this.currentPos = {x: x, y: y};
    }
  }

  moveWithCursor(pawn){
    var speed = 150
    pawn.man.body.velocity.x = 0;
    pawn.man.body.velocity.y = 0;

    if (this.cursors.left.isDown) {
      pawn.man.body.velocity.x = -speed;
      pawn.man.animations.play('walk_left');
      pawn.man.currentDirection = 'left';
      this.positionChanged(pawn);
    } else if (this.cursors.right.isDown) {
      pawn.man.body.velocity.x = speed;
      pawn.man.animations.play('walk_right');
      pawn.man.currentDirection = 'right';
      this.positionChanged(pawn);
    } else if (this.cursors.down.isDown) {
      pawn.man.body.velocity.y = speed;
      pawn.man.animations.play('walk_down');
      pawn.man.currentDirection = 'down';
      this.positionChanged(pawn);
    } else if (this.cursors.up.isDown) {
      pawn.man.body.velocity.y = -speed;
      pawn.man.animations.play('walk_up');
      pawn.man.currentDirection = 'up';
      this.positionChanged(pawn);
    } else {
      pawn.man.animations.play('standing_' + pawn.man.currentDirection);
    }
  }

}
