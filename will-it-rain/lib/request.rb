require 'excon'
require_relative 'errors'

class Request
  API_URL = 'https://www.metaweather.com/api/location/'

  class << self
    def location(city_name)
      make_request{ Excon.get("#{API_URL}search/?query=#{city_name}") }
    end

    def weather_forecast_for_tomorrow(location, date)
      make_request{ Excon.get("#{API_URL}#{location['woeid']}/#{date}/") }
    end

    private

    def make_request
      response = yield
      return response.body if response.status == 200

      puts Errors.api_error
    end
  end
end
