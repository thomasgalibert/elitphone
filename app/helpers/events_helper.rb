module EventsHelper

  # Display start_at -- end_at
  def display_gap(event)
    "#{event.patient.longname} : (#{l(event.start_at, format: :time)} - #{l(event.end_at, format: :time)})"
  end
end
