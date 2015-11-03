class EventsController < ApplicationController
  autocomplete :event, :name, full: true
  authorize_resource
  before_action :set_agenda, only: [:new, :create, :edit, :update]
  before_action :set_event, only: [:show, :edit, :update, :destroy]


  def new
    @event = @agenda.events.new
  end

  def create
    @event = @agenda.events.create!(event_params)

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

      # variables for calendar view
      @date_ref = init_date
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = @agenda.events.where(start_at: first_day..last_day)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
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
