import { Dawning } from './namespace';

Dawning.MapData = class MapData {

  constructor(map) {
    this.map = map;
    this.game = map.game;
    this.fields = [];
    for(var y = 0; y < map.size; y++){
      this.fields[y] = new Array(map.size);
    }
  }

  // floors: no physics, no collision, darken if not visible
  // obstacles: collision detection, darken if not visible
  // things: collision detection, hidden if not visible
  createData(data){
    data.forEach((row, y) => {
      row.forEach((field, x) => {
        field = {
          x: x,
          y: y,
          wall: this.parseWall(data[y][x]),
          fruit: this.parseFruit(data[y][x]),
          herbivor: data[y][x] == 'R',
          predator: data[y][x] == 'L',
          pawn: this.parsePawn(data[y][x][0], x, y),
          visible: false,
          wasVisible: false,
          floors: [],
          obstacles: [],
          things: []
        }
        this.fields[y][x] = field;
      })
    })
  }

  addFloor(sprite, x, y){
    var field = this.getField(x, y);
    if(field){
      field.floors.push(sprite);
      sprite.field = field;
    }
  }

  addObstacle(sprite, x, y){
    var field = this.getField(x, y);
    if(field){
      field.obstacles.push(sprite);
      sprite.field = field;
    }
  }

  addThing(sprite, x, y){
    var field = this.getField(x, y);
    if(field){
      field.things.push(sprite);
      sprite.field = field;
    } else {
      console.log("WARN: outside x:"+x+", y:"+y);
      console.log(sprite);
    }
  }

  removeObstacle(sprite){
    var field = sprite.field;
    var pos = field.obstacles.indexOf(sprite);
    if (pos > -1){
      field.obstacles.splice(pos, 1);
      sprite.field = null;
    }
  }

  removeThing(sprite){
    var field = sprite.field;
    var pos = field.things.indexOf(sprite);
    if (pos > -1){
      field.things.splice(pos, 1);
      sprite.field = null;
    }
  }

  parseFruit(fruit){
    let value = parseInt(fruit);
    if(value) return value;
  }

  parseWall(wall){
    if (wall == 'X' || wall == 'x' || wall == 'H'){
      return wall;
    }
  }

  parsePawn(data, x, y){
    if(typeof(data) == 'object' && data.type == 'Dungeon::Pawn'){
      return data;
    } else {
      return false;
    }
  }

  eachField(callback){
    this.fields.forEach((row, y) => {
      row.forEach((field, x) => {
        callback(field, x, y);
      })
    })
  }

  getField(x, y){
    if (this.fields[y] === undefined) return null;
    if (this.fields[y][x] === undefined) return null;
    return this.fields[y][x];
  }

  fieldProperty(x, y, outsideValue, callback){
    if (this.fields[y] === undefined) return outsideValue;
    if (this.fields[y][x] === undefined) return outsideValue;
    return callback(this.fields[y][x]);
  }

  blocksVisability(x, y){
    return this.fieldProperty(x, y, true, function(field){
      return field.wall == 'X';
    });
  }

  isWall(x, y){
    return this.fieldProperty(x, y, true, function(field){
      return field.wall;
    });
  }

  isFree(x, y){
    return this.fieldProperty(x, y, false, function(field){
      return !field.wall && !field.herbivor && !field.predator && !field.pawn;
    });
  }

  rayCast(rpos, rayLength, callback) {
    var numberOfRays = 96;
    for(var i = 0; i < numberOfRays; i++){
      var rayAngle = (Math.PI * 2 / numberOfRays) * i
      for(var j= 0; j <= rayLength; j+=1){
        var landingX = Math.round(rpos.x - j * Math.cos(rayAngle));
        var landingY = Math.round(rpos.y - j * Math.sin(rayAngle));

        callback(landingX, landingY);

        if(this.blocksVisability(landingX, landingY)){
          break;
        }
      }
    }
  }

}
