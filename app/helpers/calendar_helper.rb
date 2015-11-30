module CalendarHelper
  def calendar(date, step, events, start_hour, end_hour, agenda, view_style)
    Calendar.new(self, date, step, events, start_hour, end_hour, agenda, view_style).build_weeks
  end
end
