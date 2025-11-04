class Admin::DashboardsController < ApplicationController
  include Authentication
  layout "dashboard"

  def index
    @user = Current.user
    @consumptions = @user.consumptions.model_to_stats
    @user_summary = Consumption.user_summary(Current.user.id)
    @stats = Consumption.get_stats_data_for_charts
    @user_stats = Consumption.average_daily_for_user(Current.user.id)
  end
end
