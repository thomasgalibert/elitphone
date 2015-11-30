module PatientsHelper
  def display_gender_patient(patient)
    case patient.gender
      when "lady"   then display_icon_and_age("venus", patient.birthday, "pink")
      when "miss"   then display_icon_and_age("venus", patient.birthday, "pink")
      when "mister" then display_icon_and_age("mars", patient.birthday, "blue")
      else fa_icon("mars")
    end
  end

  private

    def display_icon_and_age(icon, birthday, color)
      fa_icon(icon, class: color)+Age.new(self, birthday).calcul
    end
end
