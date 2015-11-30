class ReminderJob < ActiveJob::Base
  queue_as :default

  def perform(event)
    @twilio_number = Rails.application.secrets.twilio_number
    @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token)
    reminder = "Bonjour #{event.patient.longname}. Ceci est un rappel de votre rdv avec le #{event.agenda.user.cabinet_detail.name} le #{ActionController::Base.helpers.localize(event.start_at, format: :short)} à #{ActionController::Base.helpers.localize(event.start_at, format: :time)}. Veuillez confirmer votre présence en répondant OUI ou NON."
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => event.patient.international_number,
      :body => reminder,
    )
    puts message.to
  end
end
