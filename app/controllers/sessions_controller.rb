class SessionsController < ApplicationController
  navigation :login
  skip_before_filter :require_login
  skip_authorization_check

  def new
  end

  def create
    user = login(params[:session][:username], params[:session][:password], params[:session][:remember_me])
    if user
      redirect_back_or_to levels_url, notice: "Welcome back #{user.username}"
    else
      flash[:error] = "Login failed"
      render 'new'
    end
  end

  def destroy
    if current_user
      username = current_user.username
      logout
      redirect_to root_url, notice: "Goodbye #{username}"
    else
      redirect_to root_url
    end
  end

end
