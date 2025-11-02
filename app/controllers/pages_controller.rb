class PagesController < ApplicationController
  allow_unauthenticated_access
  def index
    redirect_to admin_dashboard_admin_path if authenticated?
  end
end
