module EventsHelper
  def select_durations(duration)
    options = []
    number_options = 60/duration*3

    (number_options+1).times do |i|
      unless i == 0
        minutes = i*duration
        options << ["#{display_time_format(minutes)}", minutes]
      end
    end

    return options
  end

  def selected_duration(event)
    unless event.new_record?
      ((event.end_at - event.start_at)/60).to_i
    else
      event.agenda.step
    end
  end

  def build_datalist(options = {})
    id = options[:id]
    agenda = options[:agenda]
    number_options = 60/agenda.step*3
    options = ""
    (number_options+1).times do |i|
      unless i == 0
        minutes = i*agenda.step
        options << content_tag(:option, display_time_format(minutes), value: minutes)
      end
    end
    content_tag :datalist, id: id do
      options.html_safe
    end
  end

  private

    def display_time_format(minutes)
      minutes_time = Time.new(2015,01,01,0,0,0)+(minutes*60)
      if minutes >= 60
        if minutes % 60 == 0
          l(minutes_time, format: :only_hours)
        else
          l(minutes_time, format: :long_time)
        end
      else
        l(minutes_time, format: :only_minutes)
      end
    end
end
