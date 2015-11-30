class EventsController < ApplicationController
  autocomplete :event, :name, full: true
  authorize_resource
  before_action :set_agenda, only: [:new, :edit, :create, :update, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]


  def new
    @event = @agenda.events.new
    find_date_and_events(@event)
  end

  def edit
    find_date_and_events(@event)
  end

  def create
    @event = @agenda.events.create!(event_params)
    find_date_and_events(@event)
    # Send and email to advert user that an event is scheduled
    UserMailer.welcome.deliver_later
    # Redirect to day or week view
    redirect_to_agenda_view(params[:view_action], @agenda, @event)
  end

  def update
    @event.update!(event_params)
    find_date_and_events(@event)
    # Redirect to day or week view
    redirect_to_agenda_view(params[:view_action], @agenda, @event)
  end

  def destroy
    @event.destroy
  end

  #webhook for twilio incoming message from host
  def accept_or_reject
    incoming = Sanitize.clean(params[:From]).gsub(/^\+\d/, '')
    sms_input = params[:Body].downcase
    @patient = Patient.find_by(tel: incoming)
    @event = @patient.events.first

    if sms_input == "oui"
      @event.confirm!
    else
      @event.reject!
    end
  end

  private

    def set_agenda
      @agenda = current_company.agendas.find(params[:agenda_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def find_date_and_events(event)
      @date_ref = init_date
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = @agenda.events.where(start_at: first_day..last_day)
    end

    def init_date
      date_ref = params[:set_date] ? DateTime.parse(params[:set_date]) : Time.zone.now.to_datetime
    end

    def redirect_to_agenda_view(view_action, agenda, event)
      if view_action == "day"
        redirect_to show_day_agenda_path(agenda,
                    day: event.start_at,
                    user_id: agenda.user.id)
      elsif view_action == "week"
        redirect_to user_agenda_path(agenda.user,
                    agenda,
                    set_date: event.start_at)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
       :name,
       :start_at,
       :end_at,
       :duration,
       :patient_id,
       :agenda_id,
       :status,
       :recurring_status,
       :is_recurring
       )
    end
end
