module Sessions
  class LoginPage < ApplicationPage

    def open
      visit login_path
      self
    end

    def form
      find('#new_session')
    end

    def login_as username, password
      fill_form_with username: username, password: password
      submit
    end

    def fill_form_with params
      within(form) do
        fill_in 'Username', with: params[:username]
        fill_in 'Password', with: params[:password]
        check 'Remember me'
      end
    end

    def submit
      click_button 'login'
    end

    def click_forgot_password
      within('.session_password .help-block') do
        click_link 'here'
      end
    end

  end
end
