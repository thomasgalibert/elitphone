module ApplicationHelper
  # Custom link with font awesome icon before name
  def link_to_icon(name, path, options = {})
   icon = options[:icon]
   link_to path, options do
     fa_icon(icon)+" "+name
   end
  end

  # Custom link with font awesome icon stacked
  def link_to_stack_icon(name, path, options = {})
   icon = options[:icon]
   link_to path, options do
     fa_stacked_icon("#{icon} inverse",
      base: "circle",
      class: "fa-2x black icon-nav")
   end
  end

  # Display link company if current_user
  def display_link_company
    if current_user
      link_to(current_company.name, '#')
    else
      ""
    end
  end

  # Display lock icon if not identified and icon user if logged
  def display_icon_connexion
    if current_user
      link_to logout_path, class: "icon-link" do
        fa_stacked_icon "sign-out inverse",
        base: "circle",
        class: "fa-2x primary icon-nav"
      end
    else
      link_to login_path, class: "icon-link" do
        fa_stacked_icon "lock inverse",
        base: "circle",
        class: "fa-2x primary icon-nav"
      end
    end
  end

  # Display notification icon with object number exposant
  def display_notification_stack(icon, number)
    link_to '#', class: "icon-link" do
      content_tag :div, class: "notification-stack" do
        create_icons_stacks(icon, number)
      end
    end
  end

  # Display the title inside H1 tags if content title exists
  def display_title
    content_for(:title) ? content_tag(:h1, content_for(:title)) : ""
  end

  # Display title form for resource depending on new record or not
  def display_title_resource(object)
    object.new_record? ? t("#{object.class.name.underscore}.new") : t("#{object.class.name.underscore}.edit")
  end

  private

    def create_icons_stacks(icon, number)
      stacks = ''
      stacks << fa_stacked_icon("#{icon} inverse",
        base: "circle",
        class: "fa-2x success icon-nav bell")
      stacks << content_tag(:span, "#{number}", class: "number-bell")
      return stacks.html_safe
    end
end
