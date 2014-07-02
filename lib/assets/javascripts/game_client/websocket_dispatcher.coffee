class @WebsocketDispatcher

  constructor: (url, useWebSockets) ->
    @dispatcher = new WebSocketRails(url, useWebSockets)
    #@dispatcher.on_open = @init_map
    @bindEvents()

  init_map: =>
    console.log("trigger init_map #{@level_id()}")
    @dispatcher.trigger 'init_map', { level_id: @level_id() }

  bindEvents: =>
    @dispatcher.bind 'init_map', @render_client

  render_client: (message) =>
    console.log(message)
    window.client.render(message)

  # bindEvents: =>
  #   @dispatcher.bind 'new_message', @newMessage
  #   @dispatcher.bind 'user_list', @updateUserList
  #   $('input#user_name').on 'keyup', @updateUserInfo
  #   $('#send').on 'click', @sendMessage
  #   $('#message').keypress (e) -> $('#send').click() if e.keyCode == 13

  level_id: ->
    window.location.pathname.match(/levels\/(.*?)\/map/)[1]
