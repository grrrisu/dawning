class AuthenticationMailer < ActionMailer::Base
  default :from => 'no_reply@zero-x.net',
          :reply_to => 'dawning@zero-x.net',
          :date => Time.now

  def confirm_registration user
    @user = user
    mail :to => user.email, :subject => 'Please confirm your registration'
  end

  def activation user
    @user = user
    mail :to => user.email, :subject => 'Your account is active'
  end

  def reset_password user
    @user = user
    mail :to => user.email, :subject => 'Reset Password'
  end
end
