import { Dawning } from './namespace';

Dawning.Game = class Game {

  constructor(options){
    this.game = new Phaser.Game(
          options.width,
          options.height,
          Phaser.AUTO,
          options.element,
          this
    );
    this.foodCollected = 0;
    this.map = new Dawning.IsoMap(this, options);
    //this.fog = new Dawning.Fog(this, this.map.mapSize);
    this.websocket = new Dawning.Websocket(this);
  }

  preload(){
    this.game.load.audio('rainforest', '/audio/rainforest_ambience.mp3');
    //this.game.load.audio('footsteps', 'audio/footsteps_dry_wheat.mp3');

    this.map.preload();
  }

  create(){
    this.websocket.trigger('init_dungeon');

    this.game.world.setBounds(0, 0, 3 * this.map.mapSize, 3 * this.map.mapSize);

    var backgroundSound = this.game.add.audio('rainforest', 0.1, true); // key, volume, loop
    //var footstepsSound  = this.game.add.audio('footsteps', 1.0,  true);
    backgroundSound.play();
  }

  createFromData(data){
    //this.fog.create();
    this.map.createFromData(data['fields']);

    this.foodScore = this.game.add.text(20, 20, "Food: 0", { font: "32px Arial", fill: "#ffffff", align: "center" });
    this.foodScore.fixedToCamera = true;
  }

  update(){
    //this.fog.update();
    this.map.update();
  }

  render(){
    this.map.render();
  }

  collectBanana(man, banana) {
    var position = {isoX: banana.isoX, isoY: banana.isoY};
    this.websocket.trigger('food_collected', {position: position});
    banana.animations.play('empty');
  }

  attacked(man, leopard){
    this.map.leopardBuilder.roaring.play();
    man.kill();
    leopard.body.velocity.x = 0;
    leopard.body.velocity.y = 0;
    console.log("GAME OVER!");
    this.websocket.trigger('game_over', {totalFood: this.foodCollected, position: {isoX: man.isoX, isoY: man.isoY}})
  }

  updateFoodCollected(data){
    this.foodCollected  = data;
    this.foodScore.text = 'Food: ' + this.foodCollected;
  }

}
