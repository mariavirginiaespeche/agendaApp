class UserMailer < ApplicationMailer
    def event_created_email(worker, event)
      @worker = worker
      @event = event
      mail(to: @worker.email, subject: 'Nuevo Evento Creado')
    end
  end
  