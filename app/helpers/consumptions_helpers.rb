module ConsumptionsHelpers
  def format_consumption_date(date)
    date.strftime("%d/%m/%Y")
  end

  def consumption_type_label(consumption)
    case consumption.consumption_type
    when "electricity"
      render(partial: "shared/electricity")
    when "water"
      render(partial: "shared/water")
    when "gas"
      render(partial: "shared/gas")
    else
      consumption.consumption_type.capitalize
    end
  end
  def consumption_measure_label(consumption)
    case consumption.consumption_type
    when "electricity"
      "kW"
    when "water"
      "L."
    when "gas"
      "m³"
    else
      consumption.measure
    end
  end
  def consumption_select_options
    [
      [ "Elettricità", "electricity" ],
      [ "Acqua", "water" ],
      [ "Gas", "gas" ]
    ]
  end
end
