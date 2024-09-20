class WeatherService
    include HTTParty
    base_uri 'https://api.openweathermap.org/data/2.5'
    
    def initialize(api_key)
      @api_key = api_key
    end
    
    def get_weather(city)
      response = self.class.get('/weather', query: { q: city, appid: @api_key, units: 'metric' })
  
      if response.success?
        response
      else
        { success: false, message: response.message }
      end
    rescue StandardError => e
      { success: false, message: e.message }
    end
  end
  