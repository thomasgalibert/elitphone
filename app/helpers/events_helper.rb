module EventsHelper

  # Display start_at -- end_at
  def display_gap(event)
    "#{event.patient.longname} : (#{l(event.start_at, format: :time)} - #{l(event.end_at, format: :time)})"
  end

  # Build icon calendar with from time to time
  def build_calendar_gap(options = {})
    from = options[:from].to_datetime
    to   = options[:to].to_datetime
    content_tag :time, class: 'calendar-icon' do
      content_tag(:em, l(from, format: :only_month))+
      content_tag(:strong, l(from, format: :only_day_number))+
      content_tag(:span, l(from, format: :only_day_name))+
      content_tag(:cite, "#{l(from, format: :time)} - #{display_gap_calendar(from, to)}")
    end
  end

  # Display the changes between the two object
  # for start_at, end_at, status, comments fields
  def display_what_changed_to_event(track)
    "#{l(track.start_at, format: :short_time)} - "+
    "#{l(track.end_at, format: :short_time)} - "+
    "#{display_status(track.status)} - #{track.comments}"
  end

  private

    def display_gap_calendar(from, to)
      gap = ((to - from)*1440).to_f
      display_hours_and_minutes(gap)
    end

    def display_hours_and_minutes(gap)
      minutes_left = (gap % 60).round
      hours = (gap / 60).floor
      if minutes_left == 0
        "#{hours} h."
      elsif hours < 1
        "#{minutes_left} min."
      else
        "#{hours} h #{minutes_left}"
      end
    end

    def display_status(status)
      case status
        when "pending" then t('event.statuts.pending')
        when "confirmed" then t('event.statuts.confirmed')
        when "rejected" then t('event.statuts.rejected')
        else
          status
      end
    end
end
