class Admin::DashboardsController < ApplicationController
  include Authentication
  layout "dashboard"

  def index
    @user = Current.user
  end
end
