class Event < ActiveRecord::Base

  # VALIDATIONS
  validates :agenda_id, :patient_id, :start_at, :duration, presence: true

  attr_accessor :duration

  before_save :save_end_at

  # RELATIONSHIPS
  belongs_to :patient
  belongs_to :agenda

  # CALLBACKS TO UPDATE END AT Attribute according to duration

  def save_end_at
    self.end_at = self.start_at + duration.to_i.minutes
  end
end
