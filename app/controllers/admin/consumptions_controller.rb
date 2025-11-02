class Admin::ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [ :show, :edit, :destroy ]
  include Authentication
  helper ConsumptionsHelpers
  layout "dashboard"
  def index
    @user = Current.user
    @consumptions = @user.consumptions
  end

  def show
  end

  def new
    @consumption = Consumption.new
  end
  def edit
  end

  def destroy
    puts params.inspect
    if @consumption.destroy
      redirect_to admin_consumptions_path, notice: { title: "Consumo eliminato con successo.", description: "Il consumo è stato eliminato definitivamente dal sistema."}
    end
  end

  private

  def set_consumption
    @consumption = Consumption.find(params[:id])
  end
end
