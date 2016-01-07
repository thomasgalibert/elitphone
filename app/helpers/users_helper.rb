module UsersHelper
  def display_icon_role(user)
    case user.role
      when "cabinet" then fa_icon('stethoscope')
      when "secretary" then fa_icon('paperclip')
    else "--"
    end
  end

  def display_class_secretary(user)
    user.secretary? ? "small" : ""
  end
end
