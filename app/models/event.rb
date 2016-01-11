class Event < ActiveRecord::Base
  # VALIDATIONS
  validates :agenda_id, :patient_id, :start_at, :end_at, presence: true

  # RELATIONSHIPS
  belongs_to :patient
  belongs_to :agenda
  has_many :tracks

  # SCOPES
  default_scope { order('start_at ASC')}
  scope :onday, ->(day) { where('start_at BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day) }
  scope :onweek, ->(day) { where('start_at BETWEEN ? AND ?', day.beginning_of_week, day.end_of_week) }


  # CALLBACKS
  # after_save :send_reminder
  after_save :broadcast_event
  after_destroy :broadcast_event
  before_update :track_changes

  # Vitual Attributes
  attr_accessor :updated_by

  # COMPUTED METHODS
  def gap
    "(#{ActionController::Base.helpers.localize(self.start_at, format: :short_time)} - #{ActionController::Base.helpers.localize(self.end_at, format: :short_time)})"
  end

  def created_by_name
    "#{User.find(self.created_by).longname}"
  end

  def track_changes
    Track.create(
      event_id: self.id,
      user_id:  User.find(self.updated_by).id,
      start_at: self.start_at,
      end_at:   self.end_at,
      status:   self.status,
      comments: self.comments
    )
  end

  STATUTS = [["pending", I18n.t('event.statuts.pending')], ["confirmed", I18n.t('event.statuts.confirmed')], ["rejected", I18n.t('event.statuts.rejected')]]

  def confirm!
    self.status = "confirmed"
    self.save!
  end

  def reject!
    self.status = "rejected"
    self.save!
  end

  def send_reminder
    ReminderJob.perform_later(self.to_global_id.to_s)
  end

  def broadcast_event
    ActionCable.server.broadcast "agendas:#{self.agenda.id}",
         event: AgendasController.render(
           partial: 'agendas/week',
           locals: {
             date_ref: self.start_at.to_datetime,
             events: self.agenda.events.onweek(self.start_at),
             agenda: self.agenda,
             view_action: "week"
           }
         )
  end

end
