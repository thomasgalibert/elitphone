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
  before_save :reminder

  # Computed methods

  def longname
    "#{firstname} #{name}"
  end

  def international_number
    "+33#{tel[1..-1].gsub(/\s+/, "")}"
  end

  def reminder
    @twilio_number = Rails.application.secrets.twilio_number
    @client = Twilio::REST::Client.new(Rails.application.secrets.twilio_sid, Rails.application.secrets.twilio_token)
    reminder = "Salut #{self.longname}. Juste un petit essai pour la nouvelle appli de toto ;-)"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => self.international_number,
      :body => reminder,
    )
    puts message.to
  end
end
