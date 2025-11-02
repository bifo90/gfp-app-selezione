class Admin::ConsumptionsController < ApplicationController
  include Authentication
  layout "dashboard"
  def index
    @user = Current.user
    @consumptions = @user.consumptions
  end
end
