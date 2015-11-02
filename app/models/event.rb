class Event < ActiveRecord::Base
  validates :name, presence: true

  attr_accessor :duration

  before_save :save_end_at

  # VALIDATIONS
  belongs_to :patient

  # CALLBACKS TO UPDATE END AT Attribute according to duration

  def save_end_at
    self.end_at = self.start_at + duration.to_i.minutes
  end
end
