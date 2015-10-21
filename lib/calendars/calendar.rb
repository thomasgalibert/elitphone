class Calendar < Struct.new(:view, :date, :step, :events, :start_hour, :end_hour)

  delegate :content_tag, :l, :t, :fa_icon, :link_to, to: :view
##############################################################################
# Build a week calendar view according to these parameters                   #
# 1 - a date                                                                 #
# 2 - a step to make appointment  : ex 15 min, 30 min, etc.                  #
# 3 - array of events to display                                             #
# 4 - the first and the last hour of the day                                 #
##############################################################################

  def build_weeks
    # 1 - find the first and the last day of the week
    first_day = date.beginning_of_week
    last_day = date.end_of_week

    # 2 - build the column of the timestamps
    cols = ""
    cols << content_tag(:div,
             build_col_hours(first_day, step, start_hour, end_hour),
             class: "day-row hour-row")

    # 3 - build the column of the events
    (first_day..last_day).collect do |day|
      cols << content_tag(:div,
               build_col_day(day, step, events, start_hour, end_hour),
               class: "day-row")
    end
    return cols.html_safe # Finaly - Return all htmls
  end



  private

    ############################################################################
    # Methods to build the htmls ###############################################
    ############################################################################

    def build_col_day(day, step, events, start_hour, end_hour)
      number_div = calculate_divs(step, start_hour, end_hour).to_i
      divs = ""

      # BUILD DAYS NAMES
      divs << content_tag(:div,
                          build_day_link(day),
                          class: define_day_name_class(day))

      # BUILD CELL TIME UNIT
      number_div.times do |i|
        minutes = step*i
        divs << content_tag(:div,
                 find_name_event(minutes, day,
                                 select_events_in_day(
                                   day, events, minutes, start_hour),
                                 start_hour),
                 class: define_class_step(minutes.to_i),
                 data: {date: "#{calculate_horaire(minutes, day, start_hour)}"})
      end
      return divs.html_safe
    end

    def build_col_hours(first_day, step, start_hour, end_hour)
      number_div = calculate_divs(step, start_hour, end_hour).to_i
      random_date = DateTime.new()
      hours = ""

      hours << content_tag(:div,
                           l(first_day, format: :weeknumber),
                           class: define_day_name_class(first_day))

      number_div.times do |i|
        minutes = step*i
        hours << content_tag(:div,
                             display_clock(minutes, random_date, start_hour),
                             class: define_class_minute(minutes.to_i))
      end
      return hours.html_safe
    end

    def find_name_event(minutes, day, event, start_hour)
      horaire = calculate_horaire(minutes, day, start_hour)
      name = ""
      if event
        if event.start_at == horaire
          name << content_tag(:div,
                              event.name,
                              class: "rdv active",
                              data: {id: event.id})
        elsif horaire > event.start_at && horaire < event.end_at
          name << content_tag(:div, "", class: "rdv active")
        else
          name << content_tag(:div, "", class: "rdv")
        end
      else
        name << content_tag(:div, "", class: "rdv")
      end
      return name.html_safe
    end

    def display_clock(minutes, date, start_hour)
      content_tag(:div, display_time_div(minutes, date, start_hour), class: "rdv")
    end

    def display_time_div(minutes, date, start_hour)
      content_tag(:div,
                  l(calculate_horaire(minutes, date, start_hour), format: :time),
                  class: define_class_timestamp(minutes))
    end

    def build_day_link(day)
      links = ""
      if day.monday?
        links << link_to(t('prev_arrow'), view.events_path(set_date: day-1))
        links << "&nbsp;"
        links << l(day, format: :calendar)
        links << "&nbsp;" if day.holiday?(:fr)
        links << fa_icon("gift") if day.holiday?(:fr)
      elsif day.sunday?
        links << fa_icon("gift") if day.holiday?(:fr)
        links << "&nbsp;" if day.holiday?(:fr)
        links << l(day, format: :calendar)
        links << "&nbsp;"
        links << link_to(t('next_arrow'), view.events_path(set_date: day+1))
      else
        links << fa_icon("gift") if day.holiday?(:fr)
        links << "&nbsp;" if day.holiday?(:fr)
        links << l(day, format: :calendar)
      end
      return links.html_safe
    end

    ############################################################################
    # Methods to calculate and events picking ##################################
    ############################################################################

    def calculate_horaire(minutes, day, start_hour)
      horaire = day + start_hour.hours + minutes.minutes
    end

    def calculate_divs(step, start_hour, end_hour)
      gap = end_hour - start_hour
      number_div = 60/step*gap
    end

    def select_events_in_day(day, events, minutes, start_hour)
      events_of_day = []
      events.each do |event|
        if (event.start_at <= calculate_horaire(minutes, day, start_hour) &&
            event.end_at >= calculate_horaire(minutes, day, start_hour))
          events_of_day << event
        end
      end
      return events_of_day[0]
    end

    ############################################################################
    # Methods to display the appropriate css class #############################
    ############################################################################

    def define_class_step(minutes)
      minutes % 60 == 0 ? "step hour" : "step"
    end

    def define_class_minute(minutes)
      minutes % 60 == 0 ? "step hour timehour" : "step time"
    end

    def define_class_timestamp(minutes)
      minutes % 60 == 0 ? "timestamp hourstamp" : "timestamp normalstamp"
    end

    def define_day_name_class(day)
      unless day.holiday?(:fr)
        if day.today?
          "day-number today"
        elsif day.saturday? || day.sunday?
          "day-number week-end"
        else
          "day-number"
        end
      else
        "day-number holiday"
      end
    end
end
