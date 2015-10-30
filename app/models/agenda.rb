class Agenda < ActiveRecord::Base
  # RELATIONSHIPS
  belongs_to :company
  belongs_to :user

  # VALIDATIONS
  validates :name, :step, :start_hour, :end_hour, presence: true
  validates :step, numericality: {only_integer: true, greater_than: 0}
  validates :start_hour, :end_hour, numericality: {greater_than: 0}
end
