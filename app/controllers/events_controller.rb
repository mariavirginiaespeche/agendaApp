class EventsController < ApplicationController
  def index
    @events = Event.order(start_time: :asc)

    respond_to do |format|
      format.html 
      format.json { render json: @events }
    end
  end

  def new
    @event = Event.new
    @workers = Worker.all
    @selected_worker_id = params[:worker_id] if params[:worker_id].present?
  end

  def new_without_worker
    @event = Event.new
    @workers = Worker.all
    @selected_worker_id = nil # No seleccionamos ningún trabajador
  end

  def create
    @event = Event.new(event_params)
  
    # Asigna nil a worker_id si no se selecciona un trabajador
    @event.worker_id = params[:event][:worker_id].presence || nil
  
    if @event.save
      # Lógica para manejar el clima
      weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
      if @event.location.present?
        weather_response = weather_service.get_weather(@event.location)
  
        # Para depurar
        Rails.logger.debug "Weather Response: #{weather_response.inspect}"
  
        if weather_response.is_a?(Hash) && weather_response['cod'] == 200
          @event.weather_info = weather_response['weather'].first['description']
        else
          @event.weather_info = 'Información del clima no disponible'
        end
  
        @event.update(weather_info: @event.weather_info)
      end
  
      # Enviar correo a los trabajadores sobre el evento creado
      if @event.worker_id.present?
        worker = Worker.find(@event.worker_id)
        SendEmailService.send_event_created_email(worker, @event)
      end
      
      redirect_to events_path, notice: 'Evento creado exitosamente.'
    else
      render :new_without_worker
    end
  end
  

  def fetch_weather
    weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
    weather_response = weather_service.get_weather(params[:location])
    
    if weather_response.is_a?(Hash) && weather_response['cod'] == 200
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
