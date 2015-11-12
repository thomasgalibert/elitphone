class Agenda < ActiveRecord::Base
  # RELATIONSHIPS
  belongs_to :company
  belongs_to :user
  has_many :events

  # VALIDATIONS
  validates :name, :step, :start_hour, :end_hour, presence: true
  validates :step, numericality: {only_integer: true, greater_than: 0}
  validates :start_hour, :end_hour, numericality: {greater_than: 0}

  # CALLBACKS
  before_save :save_name_cabinet

  def save_name_cabinet
    self.name_cabinet = self.user.cabinet_detail.name
  end

  # Computed methods

  def display_results
    "#{name_cabinet} : #{name}"
  end

end
