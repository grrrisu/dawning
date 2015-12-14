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

    this.dispatcher.bind('update_food_points', (data) => {
      this.game.updateFoodCollected(data.food_points);
    });

    this.dispatcher.bind('dungeon_end', (data) => {
      this.game.updateFoodCollected(data.food_points);
      if(data.rank == 1) {
        console.log("YOU WIN!!!");
      } else if (data.rank == 0){
        console.log("GAME OVER!!!");
      }
    })
  }

}
