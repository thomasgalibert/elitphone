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
