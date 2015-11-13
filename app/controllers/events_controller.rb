class EventsController < ApplicationController
  autocomplete :event, :name, full: true
  authorize_resource
  before_action :set_agenda, only: [:new, :edit, :create, :update]
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
    # Send and email
    UserMailer.welcome.deliver_later

    # Broadcast the event and render calendar view
    ActionCable.server.broadcast 'events',
      event: AgendasController.render(
        partial: 'agendas/week',
        locals: {
          date_ref: @date_ref,
          events: @events,
          agenda: @agenda
        }
      )

    head :ok
  end

  def update
    @event.update!(event_params)
    find_date_and_events(@event)

    # Broadcast the event and render calendar view
    ActionCable.server.broadcast 'events',
      event: AgendasController.render(
        partial: 'agendas/week',
        locals: {
          date_ref: @date_ref,
          events: @events,
          agenda: @agenda
        }
      )

    head :ok
  end

  def destroy
    @event.destroy
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
       :name,
       :start_at,
       :end_at,
       :duration,
       :patient_id,
       :agenda_id
       )
    end
end
