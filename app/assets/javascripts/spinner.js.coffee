$ () ->

  $('.main-section').on 'ajax:before', '.spinner', (e) =>
    $(e.target).attr('disabled', true)
    $(e.target).find('i').addClass('icon-spinner icon-spin')

  $('.submit-once').on 'submit', (e) =>
    $(e.target).find("button[type='submit']").attr('disabled', true)
