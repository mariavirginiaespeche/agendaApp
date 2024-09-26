class SendEmailService
  def self.send_event_created_email(worker, event)
    UserMailer.event_created_email(worker, event).deliver_now
  end
end

  