class @WebsocketDispatcher

  constructor: (url, useWebSockets) ->
    @dispatcher = new WebSocketRails(url, useWebSockets)
    #@dispatcher.on_open = @init_map
    @bindEvents()

  trigger: (action, params) =>
    params = {} unless params?
    $.extend(params, { level_id: @level_id() })
    console.log("trigger #{action} #{params}")
    @dispatcher.trigger action, params

  init_map: =>
    @trigger 'init_map'

  view: (request_data) =>
    @trigger 'view', request_data

  move: (request_data) =>
    @trigger 'move', request_data

  bindEvents: =>
    @dispatcher.bind 'init_map', @render_client
    @dispatcher.bind 'view', @render_map
    @dispatcher.bind 'move', @render_pawn

  render_client: (message) =>
    console.log(message)
    window.client.render(message)

  render_map: (message) =>
    console.log(message)
    window.client.map.render_fields(message)

  render_pawn: (message) =>
    console.log(message)
    headquarter = window.client.headquarter
    if headquarter.id == message['pawn_id']
      headquarter.update(message)
    else
      pawn = headquarter.findPawn(message['pawn_id'])
      if pawn?
        pawn.update(message)
      else
        console.log("can not update pawn #{message['pawn_id']}, pawn not found")


  # bindEvents: =>
  #   @dispatcher.bind 'new_message', @newMessage
  #   @dispatcher.bind 'user_list', @updateUserList
  #   $('input#user_name').on 'keyup', @updateUserInfo
  #   $('#send').on 'click', @sendMessage
  #   $('#message').keypress (e) -> $('#send').click() if e.keyCode == 13

  level_id: ->
    window.location.pathname.match(/levels\/(.*?)\/map/)[1]
