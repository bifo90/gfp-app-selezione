class Admin::DashboardsController < ApplicationController
  include Authentication
  layout "dashboard"

  def index
    @user = Current.user
    @consumptions = @user.consumptions.model_to_stats
  end
end
