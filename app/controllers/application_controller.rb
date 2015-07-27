class ApplicationController < ActionController::Base
  include Navigation

  protect_from_forgery with: :exception

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
    unless request.xhr?
      redirect_to login_path, alert: "Please login first."
    else
      render json: { location: login_path, alert: "Please login first." }, status: 403
    end
  end

  def show_map?
    navigation_active?([:map]) || navigation_active?([:admin, :test_map])
  end

end
