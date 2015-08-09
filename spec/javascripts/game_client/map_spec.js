describe("Map", function() {

  beforeEach(function(){
    stage = new PIXI.Container(0x454545);
    map   = new Game.Map(stage,
                {
                  width: 1040,
                  height: 520,
                  fieldSize: 55
                });
  });

  describe("position convertion", function() {

    it("should convert absolute position", function() {
      position = map.toRelativePosition(-43, -80);
      expect(position.rx).toEqual(0);
      expect(position.ry).toEqual(1);
    });

    it("should restrict position(5,0) to radius 3", function(){
      restrictedPosition = map.restrictToRadius(5, 0, 3, 1);
      expect(restrictedPosition.dx).toEqual(3);
      expect(restrictedPosition.dy).toEqual(0);
    });

    it("should restrict position(5,5) to radius 3", function(){
      restrictedPosition = map.restrictToRadius(5, 5, 3, 1);
      expect(restrictedPosition.dx).toEqual(2);
      expect(restrictedPosition.dy).toEqual(2);
    });

  });

});
