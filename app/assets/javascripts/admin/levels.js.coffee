$ () ->
  $('#create_level_button').on 'click', (e) =>
    e.preventDefault()
    $('#level_form').slideToggle()
    $('#level_name').focus()
