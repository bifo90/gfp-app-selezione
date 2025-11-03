class Admin::ConsumptionsController < ApplicationController
  before_action :set_consumption, only: [ :show, :edit, :update, :destroy ]
  include Authentication
  helper ConsumptionsHelpers

  layout "dashboard"
  def index
    @user = Current.user
    consumptions = @user.consumptions
    if params[:consumption_type].present?
      consumptions = consumptions.where(consumption_type: params[:consumption_type])
    end
    if params[:start_date].present?
      consumptions = consumptions.where("date >= ?", params[:start_date])
    end
    if params[:end_date].present?
      consumptions = consumptions.where("date <= ?", params[:end_date])
    end
    if params[:ordering].present?
      order_field, order_direction = params[:ordering].split
      consumptions = consumptions.order(order_field => order_direction)
    end
    @pagy, @consumptions = pagy(:offset, consumptions.order(date: :desc))
  end

  def show
  end

  def new
    @consumption = Consumption.new
  end

  def create
    @consumption = Consumption.new(consumption_params)
    if @consumption.save
      redirect_to admin_consumptions_path, notice: { title: "Consumo creato con successo.", description: "Il nuovo consumo è stato registrato nel sistema."}
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @consumption.update(consumption_params)
      redirect_to admin_consumptions_path, notice: { title: "Consumo aggiornato con successo.", description: "Le modifiche al consumo sono state salvate nel sistema."}
    else
      render :edit, status: :unprocessable_entity, alert: { title: "Errore durante l'aggiornamento del consumo.", description: "Si è verificato un errore durante il salvataggio delle modifiche. Riprova."}
    end
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

  def consumption_params
    params.require(:consumption).permit(:consumption_type, :value, :date).merge(user: Current.user)
  end
end
