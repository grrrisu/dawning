class Game.ChatController
  template: (message) ->
    html =
      """
      <div class="message" >
        <label class="label label-info">
          [#{message.received}] #{message.username}
        </label>&nbsp;
        #{message.msg_body}
      </div>
      """
    $(html)

  userListTemplate: (userList) ->
    userHtml = ""
    for user in userList
      userHtml = userHtml + "<li>#{user.username}</li>"
    $(userHtml)

  constructor: (dispatcher) ->
    @messageQueue = []
    @dispatcher = dispatcher
    @bindEvents()

  bindEvents: =>
    @dispatcher.bind 'new_message', @newMessage
    @dispatcher.bind 'user_list', @updateUserList
    $('#send').on 'click', @sendMessage
    $('#message').keypress (e) -> $('#send').click() if e.keyCode == 13

  newMessage: (message) =>
    @messageQueue.push message
    @shiftMessageQueue() if @messageQueue.length > 10
    @appendMessage message

  sendMessage: (event) =>
    event.preventDefault()
    message = $('#message').val()
    @dispatcher.trigger 'new_message', {msg_body: message}
    $('#message').val('')

  updateUserList: (userList) =>
    $('#user-list').html @userListTemplate(userList)

  appendMessage: (message) ->
    messageTemplate = @template(message)
    $('#conversation').append messageTemplate
    messageTemplate.slideDown 140

  shiftMessageQueue: =>
    @messageQueue.shift()
    $('#chat div.message:first').slideDown 100, ->
      $(this).remove()
