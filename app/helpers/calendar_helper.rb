module CalendarHelper
  def calendar(date, step, events, start_hour, end_hour)
    Calendar.new(self, date, step, events, start_hour, end_hour).build_weeks
  end
end
