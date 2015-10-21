module ApplicationHelper
  # Custom link with font awesome icon before name
  def link_to_icon(name, path, options = {})
   icon = options[:icon]
   link_to path, options do
     fa_icon(icon)+" "+name
   end
  end
end
