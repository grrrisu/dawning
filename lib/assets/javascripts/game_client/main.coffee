class Game.Main

  constructor: (element_id, level_id) ->
    @assets    = new Game.Assets();
    @apiCaller = new Game.ApiCaller();
    @stage     = new Game.Stage(element_id);

  init: () =>
    @assets.load(@assetsLoaded);
    @stage.map.init(@dataLoaded);

  assetsLoaded: () =>
    if @dataLoaded == true
      @create();
    else
      @assetsLoaded = true
      console.log("assets loaded first");
    requestAnimationFrame(@stage.update);

  dataLoaded: (initData) =>
    @initData = initData;
    if @assetsLoaded == true
      @create();
    else
      @dataLoaded = true
      console.log("data loaded first");

  create: () =>
    @headquarter = new Game.Headquarter(@initData, @stage.map);
    @stage.create();
