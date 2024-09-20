class EventsController < ApplicationController
    def index
      @events = Event.order(start_time: :asc)
    end
  
    def new
      @event = Event.new
      @workers = Worker.all
    end
  
    def create
      @event = Event.new(event_params)
      @event.worker_id = nil if params[:event][:worker_id].blank?
  
      if @event.save
        weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
        weather_response = weather_service.get_weather(@event.location) if @event.location.present?
        @event.weather_info = weather_response.success? ? weather_response['weather'].first['description'] : 'Información del clima no disponible'
        @event.save
        @workers = Worker.all
        @workers.each { |worker| SendEmailService.send_event_created_email(worker, @event) }
        redirect_to events_path, notice: 'Evento creado exitosamente.'
      else
        render :new
      end
    end
  
    def fetch_weather
      weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
      weather_response = weather_service.get_weather(params[:location])
      if weather_response.success?
        render json: { success: true, weather: weather_response['weather'].first['description'] }
      else
        render json: { success: false, message: 'Información del clima no disponible' }
      end
    end
  
    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to events_path, notice: 'Evento eliminado exitosamente.'
    end
  
    private
  
    def event_params
      params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :worker_id)
    end
  end
  