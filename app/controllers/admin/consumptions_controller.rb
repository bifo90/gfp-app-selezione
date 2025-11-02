class Admin::ConsumptionsController < ApplicationController
  include Authentication
  layout "dashboard"
  def index
    @consumptions = Current.user.consumptions
  end
end
