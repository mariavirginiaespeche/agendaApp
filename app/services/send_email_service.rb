class SendEmailService
    def self.send_event_created_email(worker, event)
      from = Email.new(email: 'virginia.espechekaram@gmail.com', name: 'Tu Nombre')
      to = Email.new(email: worker.email)
  
      subject = 'Nuevo Evento Creado'
      content = Content.new(type: 'text/plain', value: <<~TEXT)
        Se ha creado un nuevo evento:
        Título: #{event.title}
        Fecha y hora: #{event.start_time}
        Ubicación: #{event.location}
        Clima: #{event.weather_info}
      TEXT
  
      # Crear el objeto Mail
      mail = Mail.new
      mail.from = from
      mail.subject = subject
      mail.add_personalization(Personalization.new.add_to(to))
      mail.add_content(content)
  
      # Crear el cliente de SendGrid
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  
      # Enviar el correo
      response = sg.client.mail._('send').post(request_body: mail.to_json)
  
      Rails.logger.info(response.body) # Ver la respuesta
      response.status_code
    rescue StandardError => e
      Rails.logger.error("Error al enviar correo: #{e.message}")
      nil
    end
  end
  