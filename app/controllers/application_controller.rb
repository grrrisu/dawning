class ApplicationController < ActionController::Base
  include Navigation

  protect_from_forgery with: :exception

  before_filter :require_login, except: [:not_authenticated]

  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    logger.warn "rescue from access denied: #{exception.message}"
    redirect_to root_url, alert: exception.message
  end

private

  def self.public_page options = {}
    skip_before_filter :require_login, options
    skip_authorization_check options
  end

  def not_authenticated
    unless request.xhr?
      redirect_to login_path, alert: "Please login first."
    else
      render json: { location: login_path, alert: "Please login first." }, status: 403
    end
  end

  def get_running_level
    if @level =  LevelManager.instance.find(params[:level_id])
      if current_user.admin?
        raise Exception, "level #{params[:level_id]} is not yet build" if @level.state == :launched
      else
        raise Exception, "level #{params[:level_id]} is not running" unless @level.state == :running
      end
    else
      if current_user.admin?
        redirect_to admin_launch_panel_path
      else
        redirect_to levels_path
      end
    end
  end

end
