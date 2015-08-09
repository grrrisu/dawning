describe("Stage", function() {

  beforeAll(function() {
    map = document.createElement('canvas');
    map.setAttribute('id', 'map');
    map.setAttribute('width', '600')
    map.setAttribute('height', '300')
    map.setAttribute('style', 'width: 600px; height: 300px;')
    document.body.appendChild(map);

    stage = new Game.Stage('map');
  });

  it("should create stage", function() {
    expect(stage).not.toBeUndefined();
  });

  it("should create renderer", function() {
    expect(stage.renderer.width).toEqual(600 * window.devicePixelRatio);
    expect(stage.renderer.height).toEqual(300 * window.devicePixelRatio);
  });

});
