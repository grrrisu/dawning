class Game.MapController

  constructor: (@dispatcher) ->
    @bindEvents()

  init_map: =>
    @dispatcher.trigger 'init_map'

  view: (request_data) =>
    @dispatcher.trigger 'view', request_data

  move: (request_data) =>
    @dispatcher.trigger 'move', request_data

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
    window.client.render(message)

  render_map: (message) =>
    window.client.map.render_map(message)

  update_map: (message) =>
    window.client.map.update_map(message)

  render_pawn: (message) =>
    headquarter = window.client.headquarter
    if headquarter.id == message['pawn_id']
      headquarter.update(message)
    else
      pawn = headquarter.findPawn(message['pawn_id'])
      if pawn?
        pawn.update(message)
      else
        console.log("can not update pawn #{message['pawn_id']}, pawn not found")
