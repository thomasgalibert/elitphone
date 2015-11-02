class Age < Struct.new(:view, :birthday)

  delegate :content_tag, :l, :t, :fa_icon, :link_to, to: :view

  def calcul
    age = Date.today.year - birthday.year
    return " (#{age} #{t('years')})"
  end

end
