class LoginPage < ApplicationPage

  def open
    visit login_path
    self
  end

  def login_as username, password
    within('#new_session') do
      fill_in 'Username', with: username
      fill_in 'Password', with: password
      check 'Remember me'
      click_button 'login'
    end
  end

end
