class Errors
  class << self
    def too_many_results
      'To many results. Try to type city name more precisely'
    end

    def city_not_found
      'City not found. Check spelling and try again'
    end

    def api_error
      'Api error. Try again later'
    end
  end
end