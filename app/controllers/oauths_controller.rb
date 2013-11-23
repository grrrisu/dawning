class OauthsController < ApplicationController
  public_page

  # sends the user on a trip to the provider,
  # and after authorizing there back to the callback url.
  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      auto_login(@user)
      redirect_to root_path, notice: "Welcome back #{@user.username}!"
    else
      begin
        username = nil
        @user = create_from(provider) do |user|
          username = user.username
          !User.find_by_username(user.username)
        end
        if @user
          @user.activate!

          reset_session # protect from session fixation attack
          auto_login(@user)
          redirect_to edit_user_path(@user), notice: "Logged in from #{provider.titleize}!"
        else
          redirect_to login_path(@user), alert: "There is a user '#{username}' that logs in using a password"
        end
      rescue
        redirect_to login_path, alert: "Failed to login from #{provider.titleize}!"
      end
    end
  end
end
