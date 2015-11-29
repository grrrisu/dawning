import { Dawning } from './namespace';
import { Websocket } from './controllers/websocket';
import { InputHandler} from './inputHandler';
import { Fog } from './fog';
import { Thing } from './thing';
import { Pawn } from './pawn';
import { Rabbit } from './rabbit';
import { Leopard } from './leopard';
import { MapData } from './map_data';
import { Visability} from './visability';
import { IsoMap } from './iso_map';
import { Game } from './game';

var game_container = document.getElementById('game');
var height = 600;
if (game_container.offsetWidth < 700){
  height = 475;
}

Dawning.dungeon = new Dawning.Game(
  {
    width: game_container.offsetWidth,
    height: height,
    element: 'game',
    size: 25,
    fieldSize: 65
  }
);
