module Sessions
  class ResetPasswordPage < ApplicationPage


    def fill_form_with params
      fill_in 'user_password', with: params[:password]
      fill_in 'user_password_confirmation', with: params[:password]
    end

    def submit
      click_button 'Reset Password'
    end

  end
end
