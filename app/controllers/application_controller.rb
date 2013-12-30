class ApplicationController < ActionController::Base
  include Navigation

  protect_from_forgery

  before_filter :require_login, except: [:not_authenticated]

  helper_method :show_map?

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
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Please login first." }
      format.json { render json: { location: login_path, alert: "Please login first." }, status: 403}
    end
  end

  def show_map?
    # FIXME for testing only
    controller_name == 'home'
  end

end
