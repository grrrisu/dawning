class AuthenticationMailer < ActionMailer::Base
  default from: 'no_reply@zero-x.net',
          reply_to: 'dawning@zero-x.net'

  def confirm_registration user
    @user = user
    mail to: user.email, subject: 'Please confirm your registration', date: Time.now
  end

  def activation user
    @user = user
    mail to: user.email, subject: 'Your account is active', date: Time.now
  end

  def reset_password user
    @user = user
    mail to: user.email, subject: 'Reset Password', date: Time.now
  end
end
