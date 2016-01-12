module UsersHelper
  def display_icon_role(user)
    case user.role
      when "cabinet" then fa_icon('stethoscope')
      when "secretary" then fa_icon('paperclip')
      when "admin" then fa_icon('user-secret')
      when "operative" then fa_icon('phone')
    else "--"
    end
  end

  def display_icon_user_colored(user_id, status)
    # Icon html to display regarding of user's role and
    # event status
    icon = ""

    if user_id
      user = User.find(user_id)
      case user.role
        when "cabinet" then icon << fa_icon('stethoscope', class: display_color_status(status))
        when "secretary" then icon << fa_icon('paperclip', class: display_color_status(status))
        when "admin" then icon << fa_icon('user-secret', class: display_color_status(status))
        when "operative" then icon << fa_icon('phone', class: display_color_status(status))
      else "--"
      end
    else
      "--"
    end
    # Simply return the icon string
    return icon
  end

  def display_class_secretary(user)
    user.secretary? ? "small" : ""
  end

  private

    def display_color_status(status)
      case status
        when "confirmed" then "confirmed-colored"
        when "pending" then "pending-colored"
        when "rejected" then "rejected-colored"
      end
    end
end
