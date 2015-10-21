class EventsController < ApplicationController
  autocomplete :event, :name, full: true
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    load_date_and_events(params[:set_date])
    @event = Event.new
  end

  def new
    @event = Event.new
    @date_ref = init_date(params[:set_date])
  end

  def create
    @event = Event.create!(event_params)
    load_date_from_event(@event)

    # Send and email
    UserMailer.welcome.deliver_later

    # Broadcast the event and render calendar view
    ActionCable.server.broadcast 'events',
      event: EventsController.render(
        partial: 'events/week',
        locals: {
          date_ref: @date_ref,
          events: @events
        }
      )

    head :ok
  end

  def update

  end

  def destroy
    @event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Set the references dates for the calendar
    def load_date_and_events(date)
      @date_ref = init_date(date)
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = Event.where(start_at: first_day..last_day)
    end

    def load_date_from_event(event)
      @date_ref = event.start_at.to_datetime
      first_day = @date_ref.beginning_of_week
      last_day = @date_ref.end_of_week
      @events = Event.where(start_at: first_day..last_day)
    end

    def init_date(date)
      date_ref = date ? DateTime.parse(date) : Time.zone.now.to_datetime
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(
       :name,
       :start_at,
       :end_at,
       :duration
       )
    end
end
