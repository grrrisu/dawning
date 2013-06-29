$ () ->
  $('#create_level_button').on 'click', (e) =>
    e.preventDefault()
    $('#level_form').slideToggle()
    $('#level_name').focus()

  $('#cancel_launch_level').on 'click', (e) =>
    e.preventDefault()
    $('#level_form').slideUp()

