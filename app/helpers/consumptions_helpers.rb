module ConsumptionsHelpers
  def format_consumption_date(date)
    date.strftime("%d/%m/%Y")
  end

  def consumption_type_label(consumption)
    case consumption.consumption_type
    when "electricity"
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <polygon points="13 2 3 14 12 14 11 22 21 10 13 10 13 2"/>
      </svg>'.html_safe
    when "water"
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
  <path d="M12 2C12 2 4 12 4 17a8 8 0 0016 0C20 12 12 2 12 2z"/>
</svg>'.html_safe
    when "gas"
      '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24">
        <rect x="4" y="14" width="16" height="6" rx="1" ry="1" />
        <path d="M12 14v4" />
        <path d="M10 18h4" />
        <path d="M7 7c1-2 3-2 2 0s-2 2-1 4 2 0 2 0" />
        <path d="M13 6c1-2 3-2 2 0s-2 2-1 4 2 0 2 0" />
      </svg>'.html_safe
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
