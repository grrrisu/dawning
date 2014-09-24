module Sessions
  class ForgotPasswordPage < ApplicationPage

    def fill_form_with params
      fill_in 'Email', with: 'rocky@balboa.com'
    end

    def submit
      click_button 'Send Mail'
    end

  end
end
