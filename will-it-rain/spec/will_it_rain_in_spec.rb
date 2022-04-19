require File.join(File.dirname(__FILE__), '../will_it_rain_in')

RSpec.describe WillItRainIn do
  subject { described_class.new(city_name).find_weather_for_city }

  before do
    allow(Request).to receive(:location).and_return(location_api_response)
  end

  context 'With correct city name' do
    let(:city_name) { 'Paris' }
    let(:location_api_response) do
      '[{"title":"Paris","location_type":"City","woeid":615702,"latt_long":"48.856930,2.341200"}]'
    end

    before do
      allow(Request).to receive(:weather_forecast_for_tomorrow).and_return(weather_api_response)
    end
    
    context "When there is any kind of rain in the latest next day weather forecast" do
      let(:weather_api_response) do
        '[{"id":4985371420000256,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"NW","created":"2022-01-30T10:19:08.179813Z","applicable_date":"2022-01-31","min_temp":3.8949999999999996,"max_temp":8.31,"the_temp":8.129999999999999,"wind_speed":10.915520968424401,"wind_direction":309.6650091359808,"air_pressure":1024.0,"humidity":60,"visibility":11.335985345581802,"predictability":73},{"id":6185182714396672,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"NW","created":"2022-01-30T07:19:07.657886Z","applicable_date":"2022-01-31","min_temp":4.03,"max_temp":8.055,"the_temp":8.055,"wind_speed":11.131343539311752,"wind_direction":314.33550638380893,"air_pressure":1024.0,"humidity":61,"visibility":12.985104489779687,"predictability":73},{"id":5527387937701888,"weather_state_name":"Heavy Cloud","weather_state_abbr":"hc","wind_direction_compass":"NW","created":"2022-01-30T04:19:08.540222Z","applicable_date":"2022-01-31","min_temp":3.935,"max_temp":8.355,"the_temp":8.03,"wind_speed":11.05274880597842,"wind_direction":314.33550638380893,"air_pressure":1024.0,"humidity":61,"visibility":13.417268153980752,"predictability":71}]'
      end

      it 'returns message, that it is going to rain' do
        expect(subject).to eq("It's going to rain tomorrow. Don't forget your umbrella.")
      end
    end

    context "When there is no rain in the latest next day weather forecast" do
      let(:weather_api_response) do
        '[{"id":4985371420000256,"weather_state_name":"Clear","weather_state_abbr":"s","wind_direction_compass":"NW","created":"2022-01-30T10:19:08.179813Z","applicable_date":"2022-01-31","min_temp":3.8949999999999996,"max_temp":8.31,"the_temp":8.129999999999999,"wind_speed":10.915520968424401,"wind_direction":309.6650091359808,"air_pressure":1024.0,"humidity":60,"visibility":11.335985345581802,"predictability":73},{"id":6185182714396672,"weather_state_name":"Showers","weather_state_abbr":"s","wind_direction_compass":"NW","created":"2022-01-30T07:19:07.657886Z","applicable_date":"2022-01-31","min_temp":4.03,"max_temp":8.055,"the_temp":8.055,"wind_speed":11.131343539311752,"wind_direction":314.33550638380893,"air_pressure":1024.0,"humidity":61,"visibility":12.985104489779687,"predictability":73},{"id":5527387937701888,"weather_state_name":"Heavy Cloud","weather_state_abbr":"hc","wind_direction_compass":"NW","created":"2022-01-30T04:19:08.540222Z","applicable_date":"2022-01-31","min_temp":3.935,"max_temp":8.355,"the_temp":8.03,"wind_speed":11.05274880597842,"wind_direction":314.33550638380893,"air_pressure":1024.0,"humidity":61,"visibility":13.417268153980752,"predictability":71}]'
      end

      it 'returns message, that it is not going to rain tomorrow' do
        expect(subject).to eq('No rain tomorrow.')
      end
    end
  end

  context 'With incorrect city name' do
    let(:city_name) { 'Not exisiting city' }
    let(:location_api_response) { '[]' }
   
    it 'informs about incorrect city name' do
      expect(subject).to eq('City not found. Check spelling and try again')
    end
  end

  context 'When the city name is imprecise' do
    let(:city_name) { 'san' }
    let(:location_api_response) do
      '[{"title":"San Francisco","location_type":"City","woeid":2487956,"latt_long":"37.777119, -122.41964"},{"title":"San Diego","location_type":"City","woeid":2487889,"latt_long":"32.715691,-117.161720"},{"title":"San Jose","location_type":"City","woeid":2488042,"latt_long":"37.338581,-121.885567"},{"title":"San Antonio","location_type":"City","woeid":2487796,"latt_long":"29.424580,-98.494614"},{"title":"Santa Cruz","location_type":"City","woeid":2488853,"latt_long":"36.974018,-122.030952"},{"title":"Santiago","location_type":"City","woeid":349859,"latt_long":"-33.463039,-70.647942"},{"title":"Santorini","location_type":"City","woeid":56558361,"latt_long":"36.406651,25.456530"},{"title":"Santander","location_type":"City","woeid":773964,"latt_long":"43.461498,-3.810010"},{"title":"Busan","location_type":"City","woeid":1132447,"latt_long":"35.170429,128.999481"},{"title":"Santa Cruz de Tenerife","location_type":"City","woeid":773692,"latt_long":"28.46163,-16.267059"},{"title":"Santa Fe","location_type":"City","woeid":2488867,"latt_long":"35.666431,-105.972572"}]'
    end

    it 'ask to type city name more precisely' do
      expect(subject).to eq('To many results. Try to type city name more precisely')
    end
  end
end
