import { Dawning } from './namespace';

Dawning.Thing = class Thing {

  updatePosition(sprite, x, y, map){
    if(sprite.field.x != x || sprite.field.y != y){
      this.notifyNewPosition(sprite, x, y);
      map.mapData.removeThing(sprite);
      this.setPosition(sprite, x, y, map);
      map.positionChanged();
    }
  }

  setPosition(sprite, x, y, map){
    map.mapData.addThing(sprite, x, y);
    map.visability.applyThingVisability(x, y);
  }

  notifyNewPosition(sprite, x, y){
    // overwrite in subclass if position needs to be sent to the server
  }

}
