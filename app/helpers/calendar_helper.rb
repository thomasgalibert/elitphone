module CalendarHelper
  def calendar(date, step, events, start_hour, end_hour, agenda)
    Calendar.new(self, date, step, events, start_hour, end_hour, agenda).build_weeks
  end
end
