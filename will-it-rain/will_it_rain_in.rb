require 'date'
require 'json'
require_relative 'lib/request'
require_relative 'lib/errors'

class WillItRainIn
  RAIN_STATES = ['Sleet', 'Heavy Rain', 'Light Rain', 'Showers']
  
  attr_reader :city_name

  def initialize(city_name)
    @city_name = city_name
  end

  def find_weather_for_city
    response = Request.location(city_name)
    return unless response

    location = JSON.parse(response)

    case location.size
    when 1
      check_for_rain(location.first)
    when 0
      Errors.city_not_found
    else
      Errors.too_many_results
    end
  end

  private
  
  def check_for_rain(location)
    weather_forecast = JSON.parse(Request.weather_forecast_for_tomorrow(location, tomorrow))
    if RAIN_STATES.include?(weather_forecast.first['weather_state_name'])
      "It's going to rain tomorrow. Don't forget your umbrella."
    else
      'No rain tomorrow.'
    end
  end
  def tomorrow
    (Date.today + 1).strftime("%Y/%m/%d")
  end
end

puts WillItRainIn.new(ARGV[0]).find_weather_for_city