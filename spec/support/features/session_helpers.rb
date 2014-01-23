module Features
  module SessionHelpers

    def login_with(user, password)
      visit '/'
      click_link 'login'

      expect(page).to have_content('Login')
      within('#new_session') do
        fill_in 'session_username', with: user.username
        fill_in 'session_password', with: password
        sleep 1.second
        click_button 'login'
      end
    end

    def logged_in_user
      user = create :user, password: 'secret'
      login_with(user, 'secret')
      user
    end

    def logged_in_admin
      user = create :admin_user, password: 'secret'
      login_with(user, 'secret')
      user
    end

  end
end
