import { Dawning } from './namespace';

Dawning.InputHandler = class InputHandler {

  constructor(map){
    this.map = map;
    this.game = map.game;
  }

  create(){
    this.cursors = this.game.input.keyboard.createCursorKeys();
    this.mousePos = new Phaser.Plugin.Isometric.Point3();
  }

  positionChanged(pawn){
    var rpos = this.map.relativePosition(pawn.man.isoX - pawn.padding, pawn.man.isoY - pawn.padding);
    var x = Math.round(rpos.x);
    var y = Math.round(rpos.y);
    if (pawn.position.x != x || pawn.position.y != y){
      this.map.positionChanged();
      pawn.visibleArea(x, y);
      this.map.mapData.getField(pawn.position.x, pawn.position.y).pawn = null;
      pawn.position = {x: x, y: y};
      this.map.mapData.getField(x,y).pawn = pawn;

      this.map.leopardBuilder.update();
    }
  }

  movePawn(pawn){
    var speed = 150
    pawn.man.body.velocity.x = 0;
    pawn.man.body.velocity.y = 0;

    if (!this.moveWithMouse(pawn, speed)){
      if(!this.moveWithCursor(pawn, speed)){
        this.standing(pawn);
      }
    }
  }

  moveWithMouse(pawn, speed){
    if (this.game.input.mousePointer.isDown || this.game.input.pointer1.isDown) {
      this.game.iso.unproject(this.game.input.activePointer.position, this.mousePos);
      if(Math.abs(pawn.man.isoX - this.mousePos.x) > Math.abs(pawn.man.isoY - this.mousePos.y)){
        if(pawn.man.isoX > this.mousePos.x){
          this.movingLeft(pawn, speed);
        } else if (pawn.man.isoX < this.mousePos.x){
          this.movingRight(pawn, speed);
        }
      } else {
        if(pawn.man.isoY > this.mousePos.y){
          this.movingUp(pawn, speed);
        } else if (pawn.man.isoY < this.mousePos.y){
          this.movingDown(pawn, speed);
        }
      }
      return true;
    }
    return false;
  }

  moveWithCursor(pawn, speed){
    if (this.cursors.left.isDown) {
      this.movingLeft(pawn, speed);
    } else if (this.cursors.right.isDown) {
      this.movingRight(pawn, speed);
    } else if (this.cursors.down.isDown) {
      this.movingDown(pawn, speed);
    } else if (this.cursors.up.isDown) {
      this.movingUp(pawn, speed);
    } else {
      return false;
    }
    return true;
  }

  standing(pawn){
    pawn.man.animations.play('standing_' + pawn.man.currentDirection);
  }

  movingDown(pawn, speed){
    pawn.man.body.velocity.y = speed;
    pawn.man.animations.play('walk_down');
    pawn.man.currentDirection = 'down';
    this.positionChanged(pawn);
  }

  movingUp(pawn, speed){
    pawn.man.body.velocity.y = -speed;
    pawn.man.animations.play('walk_up');
    pawn.man.currentDirection = 'up';
    this.positionChanged(pawn);
  }

  movingRight(pawn, speed){
    pawn.man.body.velocity.x = speed;
    pawn.man.animations.play('walk_right');
    pawn.man.currentDirection = 'right';
    this.positionChanged(pawn);
  }

  movingLeft(pawn, speed){
    pawn.man.body.velocity.x = -speed;
    pawn.man.animations.play('walk_left');
    pawn.man.currentDirection = 'left';
    this.positionChanged(pawn);
  }

}
