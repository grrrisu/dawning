class Game.MapController

  constructor: (@dispatcher) ->
    @bindEvents()

  initMap: =>
    @dispatcher.trigger 'init_map';

  view: (request_data) =>
    request_data['current_view'] = Game.main.stage.map.data.currentView();
    @dispatcher.trigger 'view', request_data;

  update_view: (request_data) =>
    @dispatcher.trigger 'update_view', request_data;

  move: (request_data) =>
    @dispatcher.trigger 'move', request_data;

  bindEvents: =>
    @dispatcher.bind 'init_map', @render_client
    @dispatcher.bind 'view', @render_map
    @dispatcher.bind 'update_view', @update_map
    @dispatcher.bind 'move', @render_pawn

    $('#center_view').on 'click', (e) =>
      e.preventDefault()
      window.client.viewport.center()

    $('#create_new_world').on 'click', (e) =>
      e.preventDefault()
      window.client.api.get '/world', () =>
        alert('done')

  render_client: (message) =>
    Game.main.stage.map.initDataLoaded(message);

  render_map: (message) =>
    Game.main.stage.map.dataReceived(message);

  update_map: (message) =>
    Game.main.stage.map.updateMap(message)

  render_pawn: (message) =>
    pawn = Game.main.headquarter.getPawn(message.pawn_id);
    if pawn?
      pawn.movementReceived(message.x, message.y);
    else
      console.log("can not find pawn #{message.panw_id}");
