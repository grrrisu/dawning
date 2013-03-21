$(function() {
  
  // show password confirmation only if something has been entered in password
  $('#user_password_confirmation').closest('.control-group').hide();
  $('#user_password').change(function(event){
    if($(event.target).attr('value') != ''){
      $('#user_password_confirmation').closest('.control-group').slideDown();
      $('#user_password_confirmation').focus();
    } else {
      $('#user_password_confirmation').closest('.control-group').slideUp();
    }
  });
  
})

