class @GameWebsocket

  constructor: ->
    @dispatcher = new WebSocketRails($('#chat').data('uri'), true)

  trigger: (action, params) =>
    params = {} unless params?
    $.extend(params, { level_id: @level_id() })
    console.log("trigger #{action} #{params}")
    @dispatcher.trigger action, params

  bind: (action, callback) =>
    @dispatcher.bind action, callback

  level_id: ->
    window.location.pathname.match(/levels\/(.*?)\/map/)[1]
