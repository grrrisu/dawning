$ () ->
  window.client = new Client(605)
  window.client.start()

  $('body').attr('data-no-turbolink', 'true')

