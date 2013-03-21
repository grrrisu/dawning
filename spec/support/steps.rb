def login_with(user, password)
  visit '/'
  click_link 'login'

  page.should have_content('Login')
  within('#new_session') do
    fill_in 'session_username', with: user.username
    fill_in 'session_password', with: password
    sleep 1.second
    click_button 'login'
  end
end
