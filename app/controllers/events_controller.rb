# class EventsController < ApplicationController
# def index
#   @events = Event.order(start_time: :asc)
# end

# def new
#   @event = Event.new
#   @workers = Worker.all
# end

# def new_without_worker
#   @event = Event.new
#   @workers = Worker.all
#   @selected_worker_id = nil # No seleccionamos ningún trabajador

      
  
#     def create
#       @event = Event.new(event_params)
  
#       # Asigna nil a worker_id si no se selecciona un trabajador
#       @event.worker_id = params[:event][:worker_id].presence || nil
      
  
#       if @event.save
#         weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
#         if @event.location.present?
#           weather_response = weather_service.get_weather(@event.location)
  
#           # Actualiza la información del clima si la respuesta es exitosa
#           @event.weather_info = weather_response.success? ? weather_response['weather'].first['description'] : 'Información del clima no disponible'
#           @event.update(weather_info: @event.weather_info)  # Actualiza el evento solo si es necesario
#         end
  
#         @workers = Worker.all
#         @workers.each { |worker| SendEmailService.send_event_created_email(worker, @event) }
#         redirect_to events_path, notice: 'Evento creado exitosamente.'
#       else
#         render :new
#       end
#     end
  
#     def fetch_weather
#       weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
#       weather_response = weather_service.get_weather(params[:location])
#       if weather_response.success?
#         render json: { success: true, weather: weather_response['weather'].first['description'] }
#       else
#         render json: { success: false, message: 'Información del clima no disponible' }
#       end
#     end
  
#     def destroy
#       @event = Event.find(params[:id])
#       @event.destroy
#       redirect_to events_path, notice: 'Evento eliminado exitosamente.'
#     end
  
#     private
  
#     def event_params
#       params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :worker_id)
#     end
#   end
  

# class EventsController < ApplicationController
#   def index
#     @events = Event.order(start_time: :asc)
#   end

#   def new
#     @event = Event.new
#     @workers = Worker.all
#   end

#   def new_without_worker
#     @event = Event.new
#     @workers = Worker.all
#     @selected_worker_id = nil # No seleccionamos ningún trabajador
#   end

#   # resto de acciones...

#   private

#   def event_params
#     params.require(:event).permit(:title, :description, :start_time, :end_time, :location, :worker_id)
#   end
# end


class EventsController < ApplicationController
  def index
    @events = Event.order(start_time: :asc)
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

  # def create
  #   @event = Event.new(event_params)

  #   # Asigna nil a worker_id si no se selecciona un trabajador
  #   @event.worker_id = params[:event][:worker_id].presence || nil

  #   if @event.save
  #     weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
  #     if @event.location.present?
  #       weather_response = weather_service.get_weather(@event.location)

  #       # Actualiza la información del clima si la respuesta es exitosa
  #       @event.weather_info = weather_response.success? ? weather_response['weather'].first['description'] : 'Información del clima no disponible'
  #       @event.update(weather_info: @event.weather_info)  # Actualiza el evento solo si es necesario
  #     end

  #     @workers = Worker.all
  #     @workers.each { |worker| SendEmailService.send_event_created_email(worker, @event) }
  #     redirect_to events_path, notice: 'Evento creado exitosamente.'
  #   else
  #     render :new
  #   end
  # end

  # def create
  #   @event = Event.new(event_params)
  
  #   Si el evento es creado sin un trabajador, asigna nil
  #   @event.worker_id = params[:event][:worker_id].presence || "ninguno"
  
  
  #   if @event.save
  #     Aquí puedes manejar el clima como antes
  #     weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
  #     if @event.location.present?
  #       weather_response = weather_service.get_weather(@event.location)
  
  #       Actualiza la información del clima si la respuesta es exitosa
  #       @event.weather_info = weather_response.success? ? weather_response['weather'].first['description'] : 'Información del clima no disponible'
  #       @event.update(weather_info: @event.weather_info)
  #     end
  
  #     redirect_to events_path, notice: 'Evento creado exitosamente.'
  #   else
  #     render :new_without_worker # Asegúrate de renderizar el formulario correcto
  #   end
  # end
  
  def create
    @event = Event.new(event_params)
  
    # Asigna nil a worker_id si no se selecciona un trabajador
    @event.worker_id = params[:event][:worker_id].presence || nil
  
    if @event.save
      # Lógica para manejar el clima
      weather_service = WeatherService.new(ENV['OPENWEATHER_API_KEY'])
      if @event.location.present?
        weather_response = weather_service.get_weather(@event.location)
        @event.weather_info = weather_response.success? ? weather_response['weather'].first['description'] : 'Información del clima no disponible'
        @event.update(weather_info: @event.weather_info)
      end
  
      redirect_to events_path, notice: 'Evento creado exitosamente.'
    else
      render :new_without_worker
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
