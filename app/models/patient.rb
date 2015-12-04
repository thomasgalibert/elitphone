class Patient < ActiveRecord::Base

  # Default Order
  default_scope { order('name ASC') }

  # RELATIONSHIPS
  belongs_to :company
  has_many :events

  # VALIDATIONS
  validates :name, :firstname, :gender, :email, :tel, presence: true
  validates_uniqueness_of :email
  validates :email, email: true
  validates_format_of :tel, :with => /[0,0][1-9]\s(\d{2}\s)*\d{2}/

  # CALLBACKS
  # before_save :reminder

  # Computed methods

  def longname
    "#{firstname} #{name}"
  end

  def international_number
    "+33#{tel[1..-1].gsub(/\s+/, "")}"
  end

  def ziptown
    "#{zipcode} - #{town}"
  end

  def check_for_events_pending
    if pending_event
      pending_event.notify_host(true)
    end
  end

  def pending_event
    self.events.where(status: "pending").first
  end

  def pending_events
    self.events.where(status: "pending")
  end

end
