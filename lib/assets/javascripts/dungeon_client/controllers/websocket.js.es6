import { Dawning } from '../namespace';

Dawning.Websocket = class Websocket {

  constructor(game){
    this.game = game;
    this.dispatcher = new WebSocketRails($('#websocket').data('uri'), true)
    this.dispatcher.on_error = function(data) {
      console.log("ERROR: "+ data);
    };
    this.dispatcher.on_close = function(data) {
      console.log("closing websocket");
    };
    this.bindEvents();
  }

  trigger(action, params){
    this.dispatcher.trigger(action, params);
    console.log("trigger " + action + " " + params);
  }

  bindEvents(){
    this.dispatcher.bind('init_dungeon', (data) => {
      this.game.map.createFromData(data);
    });
  }

}
