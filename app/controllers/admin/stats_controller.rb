class Admin::StatsController < ApplicationController
  include Authentication
  layout "dashboard"

  def index
    @stats = Consumption.get_stats_data_for_page
  end
end
