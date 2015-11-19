var Dawning = {};

Dawning.Boot = function(game) {};

Dawning.Boot.prototype = {

  preload: function() {

  },

  create: function() {
    this.input.maxPointers = 1;
    this.stage.disableVisiabilityChange = true;
    this.stage.forceLandscape = true;
    this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
    this.scale.minWidht  = 270;
    this.scale.maxWidth  = 480;
    this.scale.pageAlignHorizontally = true;
    this.scale.pageAlignVertically = true;

    this.input.addPointer();
    this.stage.backgroundColor = '#110000';
    console.log('booted...');
  },

  update: function() {

  }

}
