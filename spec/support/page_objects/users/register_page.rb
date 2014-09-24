module Users
  class RegisterPage < ApplicationPage

    def open
      visit register_path
    end

    def fill_form_with params
      within('#new_user') do
        fill_in 'user_username', with: params[:username]
        fill_in 'user_password', with: params[:password]
        fill_in 'user_password_confirmation', with: params[:password]
        fill_in 'user_email', with: params[:email]
      end
    end

    def submit
      click_button 'register'
    end

  end
end
