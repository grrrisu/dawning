import { Dawning } from './namespace';

Dawning.Thing = class Thing {

  updatePosition(sprite, x, y, map){
    if(sprite.field.x != x || sprite.field.x != y){
      map.mapData.removeThing(sprite);
      this.setPosition(sprite, x, y, map);
      map.positionChanged();
    }
  }

  setPosition(sprite, x, y, map){
    var field = this.map.mapData.getField(x, y);
    map.mapData.addThing(sprite, x, y);
    map.visability.applyThingVisability(x, y);
  }

}
