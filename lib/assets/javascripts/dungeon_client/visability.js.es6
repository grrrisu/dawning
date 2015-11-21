import { Dawning } from './namespace';

Dawning.Visability = class Visability {

  constructor(mapData){
    this.mapData = mapData;
    this.game = mapData.game;
    this.darkness = [0xffffff, 0xdddddd, 0xcccccc, 0xbbbbbb, 0xaaaaaa, 0x999999, 0x888888, 0x777777, 0x666666];
  }

  highlightField(field){
    field.floors.forEach((sprite) => {
      this.darkenSprite(sprite, this.darkness.length -1, 0);
    });
    field.obstacles.forEach((sprite) => {
      this.darkenSprite(sprite, this.darkness.length -1, 0);
    });
    this.highlightThings(field);
  }

  highlightThings(field){
    field.things.forEach((sprite) => {
      this.game.add.tween(sprite).to({alpha: 1.0}, 500, Phaser.Easing.Quadratic.InOut, true);
    });
  }

  highlight(x, y){
    var field = this.mapData.getField(x, y);
    if(field){
      this.highlightField(field);
    }
  }

  lowlightField(field){
    field.floors.forEach((sprite) => {
      this.darkenSprite(sprite, 0, this.darkness.length -1);
    });
    field.obstacles.forEach((sprite) => {
      this.darkenSprite(sprite, 0, this.darkness.length -1);
    });
    this.lowlightThings(field);
  }

  lowlightThings(field){
    field.things.forEach((sprite) => {
      this.game.add.tween(sprite).to({alpha: 0.0}, 500, Phaser.Easing.Quadratic.InOut, true);
    });
  }

  darkenSprite(sprite, startValue, endValue){
    var colorBlend = {step: startValue};
    var colorTween = this.game.add.tween(colorBlend).to({step: endValue}, 200);
    colorTween.onUpdateCallback(() => {
      var currentStep = Math.round(colorBlend.step);
      if(currentStep == 0 && sprite.originTint){
        sprite.tint = sprite.originTint;
      } else {
        sprite.tint = this.darkness[currentStep];
      }
    });
    colorTween.start();
  }

  lowlight(x, y){
    var field = this.mapData.getField(x, y);
    if(field){
      this.lowlightField(field);
    }
  }

  lowlightAll(){
    this.mapData.eachField((field, x, y) => {
      field.floors.forEach((sprite) => {
        sprite.tint = this.darkness[this.darkness.length -1];
      });
      field.obstacles.forEach((sprite) => {
        sprite.tint = this.darkness[this.darkness.length -1];
      });
      field.things.forEach((sprite) => {
        sprite.alpha = 0.0;
      });
    });
  }

  applyThingVisability(x, y){
    var field = this.mapData.getField(x, y);
    if(field){
      if(field.visible){
        this.highlightThings(field);
      } else {
        this.lowlightThings(field);
      }
    }
  }

  isVisible(x, y){
    return this.mapData.fieldProperty(x, y, false, function(field){
      return field.visible;
    });
  }

  setAllInvisible(){
    this.mapData.eachField((field) => {
      if(field.visible){
        field.wasVisible = true;
      }
      field.visible = false;
    });
  }

  lowlightPreviousVisibles(){
    this.mapData.eachField((field) => {
      if(field.wasVisible && !field.visible){
        this.lowlightField(field);
      } else if (field.visible && !field.wasVisible){
        this.highlightField(field);
      }
      field.wasVisible = false;
    })
  }

  lookBehindField(x, y){
    var field = this.mapData.getField(x, y);
    if(field){
      field.obstacles.forEach((obstacle) => {
        this.game.add.tween(obstacle).to({alpha: 0.5}, 500, Phaser.Easing.Quadratic.InOut, true);
      });
    }
  }

  setVisible(x, y, value){
    var field = this.mapData.getField(x, y);
    if(field){
      field.visible = value;
    }
  }

}
