$ () ->

  $('.main-section').on 'ajax:before', '.spinner', (e) =>
    $(e.target).attr('disabled', true)
    $(e.target).find('i').addClass('fa-spinner fa-spin')

  $('.submit-once').on 'submit', (e) =>
    $(e.target).find("button[type='submit']").attr('disabled', true)
    $(e.target).find('button i').removeClass('fa-rocket').addClass('fa-spinner fa-spin')
