class Api::ConsumptionsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_consumption, only: [ :show ]
  def index
    render json: Consumption.all
  end
  def show
    render json: @consumption
  end

  private

  def set_consumption
    @consumption = Consumption.find(params[:id])
  end
end
