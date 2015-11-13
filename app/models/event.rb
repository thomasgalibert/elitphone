class Event < ActiveRecord::Base

  # VALIDATIONS
  validates :agenda_id, :patient_id, :start_at, :end_at, presence: true

  # RELATIONSHIPS
  belongs_to :patient
  belongs_to :agenda

  # SCOPES
  default_scope { order('start_at ASC')}
  scope :onday, ->(day) { where('start_at BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day) }

end
