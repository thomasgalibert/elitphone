class Calendar < Struct.new(:view, :date, :step, :events, :start_hour, :end_hour, :agenda, :view_style)

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
    if view_style == "day"
      first_day = date.beginning_of_day
      last_day = date.end_of_day
    else
      first_day = date.beginning_of_week
      last_day = date.end_of_week
    end

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

    def find_name_event(minutes, day, events, start_hour)
      horaire = calculate_horaire(minutes, day, start_hour)
      end_time = calculate_horaire(minutes+step, day, start_hour)
      name = ""

      # Take the events of the cell and display in a different div according to their number
      if events.count > 0 && events.count < 2
        for event in events
          # 1 - start hour event is the same as the div
          if event.start_at == horaire
            name << content_tag(:div,
                                event.patient.longname,
                                class: "rdv active",
                                data: {id: event.id})
          # 2- If the event continue to the cells
          elsif horaire > event.start_at && horaire < event.end_at
            # a) ... it ends INSIDE the cell
            if event.end_at < end_time
              name << content_tag(:div,
              "... #{event.patient.longname} (#{l(event.start_at, format: :time)})",
              class: "rdv active")
            # b) ... it takes all the cell
            else
              name << content_tag(:div,
              "... #{event.patient.longname}",
              class: "rdv active")
            end
          # 3 - The event begins INSIDE the cell
          elsif horaire < event.start_at
            name << content_tag(:div,
                    "#{l(event.start_at, format: :time)} #{event.patient.longname}",
                    class: "rdv active",
                    data: {id: event.id})
          # 4 - in the others cases, just put a class rdv
          else
            name << content_tag(:div, "", class: "rdv")
          end
        end
      # if multiples events on the same time, puts the numbers and a link to
      # open the offcanvas with the details events
      elsif events.count > 1
          name << content_tag(:div,
            link_to("!! #{events.count} rdvs",
                view.show_day_events_agenda_path(agenda,
                  day: day,
                  user_id: agenda.user.id),
                remote: true),
                class: "rdv active")
      else
        name << content_tag(:div, "", class: "rdv")
      end
      ## => return finally the html generated for the cell
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
      cabinet = agenda.user
      links = ""
      if day.monday?
        links << link_to(t('prev_arrow'), view.user_agenda_path(cabinet, agenda, set_date: day-1))
        links << "&nbsp;"
        links << display_day_link(day)
        links << "&nbsp;" if day.holiday?(:fr)
        links << fa_icon("gift") if day.holiday?(:fr)
      elsif day.sunday?
        links << fa_icon("gift") if day.holiday?(:fr)
        links << "&nbsp;" if day.holiday?(:fr)
        links << display_day_link(day)
        links << "&nbsp;"
        links << link_to(t('next_arrow'), view.user_agenda_path(cabinet, agenda, set_date: day+1))
      else
        links << fa_icon("gift") if day.holiday?(:fr)
        links << "&nbsp;" if day.holiday?(:fr)
        links << display_day_link(day)
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
      number_div = (60/step.to_f*gap.to_f).ceil
    end

    def select_events_in_day(day, events, minutes, start_hour)
      events_of_day = []
      start_cell = calculate_horaire(minutes, day, start_hour)
      end_cell = calculate_horaire(minutes+step, day, start_hour)

      events.each do |event|
        if event.start_at <= start_cell
          if event.end_at >= end_cell
            events_of_day << event
          elsif event.end_at < end_cell && event.end_at > start_cell
            events_of_day << event
          end
        else
          if event.start_at < end_cell
            events_of_day << event
          end
        end
      end
      return events_of_day
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

    def display_day_link(day)
      link_to l(day, format: :calendar), view.show_day_user_agenda_url(agenda.user, agenda, day: day, "data-no-turbolink" => true)
    end
end
