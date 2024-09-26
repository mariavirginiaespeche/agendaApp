class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather(city)
    response = self.class.get('/weather', query: { q: city, appid: @api_key, units: 'metric' })

    # Verifica si la respuesta fue exitosa
    if response.code == 200
      response.parsed_response # Devuelve la respuesta procesada
    else
      { success: false, message: response.message, cod: response.code }
    end
  rescue StandardError => e
    { success: false, message: e.message }
  end
end

