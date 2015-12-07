import { Dawning } from '../namespace';

Dawning.Websocket = class Websocket {

  constructor(game){
    this.game = game;
    this.dispatcher = new WebSocketRails($('#websocket').data('uri'), true);
    this.level_id = this.extractLevelId();
    this.dispatcher.on_error = function(data) {
      console.log("ERROR: "+ data);
    };
    this.dispatcher.on_close = function(data) {
      console.log("closing websocket");
    };
    this.bindEvents();
  }

  extractLevelId() {
    var matchData = window.location.href.match(/\/levels\/(.*?)\/dungeon$/);
    return matchData[1];
  }

  trigger(action, params = {}){
    $.extend(params, { level_id: this.level_id })
    this.dispatcher.trigger(action, params);
    console.log(`trigger ${action}`);
    console.log(params);
  }

  bindEvents(){
    this.dispatcher.bind('init_dungeon', (data) => {
      this.game.createFromData(data);
    });

    this.dispatcher.bind('food_collected', (data) => {
      this.game.updateFoodCollected(data);
    });
  }

}
