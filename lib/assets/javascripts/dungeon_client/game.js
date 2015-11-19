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
  }

  preload(){
    this.game.load.audio('rainforest', 'audio/rainforest_ambience.mp3');
    this.game.load.audio('footsteps', 'audio/footsteps_dry_wheat.mp3');

    this.map.preload();
  }

  create(){
    this.game.world.setBounds(0, 0, 3 * this.map.mapSize, 3 * this.map.mapSize);

    //this.fog.create();
    this.map.create();

    this.foodScore = this.game.add.text(0, 0, "Food: 0", { font: "32px Arial", fill: "#ffffff", align: "center" });
    this.foodScore.fixedToCamera = true;

    var backgroundSound = this.game.add.audio('rainforest', 0.1, true); // key, volume, loop
    var footstepsSound  = this.game.add.audio('footsteps', 1.0,  true);
    backgroundSound.play();
  }

  update(){
    //this.fog.update();
    this.map.update();
  }

  render(){
    this.map.render();
  }

  collectBanana(man, banana) {
    switch (banana.frame) {
      case 5:
        this.incFood(10);
        break;
      case 7:
        this.incFood(25);
        break;
      case 9:
        this.incFood(60);
        break;
    }
    banana.animations.play('empty');
  }

  attacked(man, leopard){
    this.map.leopardBuilder.roaring.play();
    man.kill();
    leopard.body.velocity.x = 0;
    leopard.body.velocity.y = 0;
    console.log("GAME OVER!");
  }

  incFood(amount){
    this.foodCollected += amount;
    this.foodScore.text = 'Food: ' + this.foodCollected;
  }

}
