require "pagy"

class ApplicationController < ActionController::Base
  # Modern Pagy pagination syntax (v9+)
  include Pagy::Method

  # Admin authentication helpers
  helper_method :current_admin
  helper_method :admin_logged_in?

  private

  def current_admin
    return @current_admin if defined?(@current_admin)

    @current_admin = Admin.find_by(id: session[:admin_id])
  end

  def admin_logged_in?
    current_admin.present?
  end

  def require_admin
    unless admin_logged_in?
      redirect_to admin_login_path,
                  alert: "Admin login required."
    end
  end
end
