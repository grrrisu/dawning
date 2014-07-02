$ () ->
  window.client = new Client(605)
  window.client.start()

  $('#center_view').on 'click', (e) =>
    e.preventDefault()
    window.client.viewport.center()

  $('#create_new_world').on 'click', (e) =>
    e.preventDefault()
    window.client.api.get '/world', () =>
      alert('done')
