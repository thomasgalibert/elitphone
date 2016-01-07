class User < ActiveRecord::Base
  has_secure_password

  # Using gravatar
  include Gravtastic
  gravtastic

  # Validations
  validates_presence_of :password, on: :create, length: { minimum: 8 }
  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :firstname
  validates_uniqueness_of :email
  validates :email, email: true

  # Relationships
  belongs_to :company, optional: true
  has_one :cabinet_detail
  accepts_nested_attributes_for :cabinet_detail
  has_many :agendas
  has_many :organisations
  has_many :participations, dependent: :destroy
  has_many :participated_organisations, through: :participations, source: :organisation

  # Callbacks
  before_save :check_is_admin?
  after_create :save_new_participation

  # Scopes
  default_scope { order('name ASC')}
  scope :cabinets, -> { where(role: "cabinet") }
  scope :secretaries, -> { where(role: "secretary") }

  # Virtuals attributes

  # When a secretary is saved, we have to create a new participation
  # to the organisation of the cabinet
  attr_accessor :organisation_id

  def save_new_participation
    unless @organisation_id.blank?
      organisation = Organisation.find(@organisation_id)
      new_participation = Participation.create(
                            user_id: self.id,
                            organisation_id: organisation.id)
    end
  end

  # Check if admin user exists for this company, if not
  # creates one
  def check_is_admin?
    if self.company.users.where(role: "admin").count == 0
      self.role = "admin"
    end
  end

  def admin?
    self.role == "admin" ? true : false
  end

  def cabinet?
    self.role == "cabinet" ? true : false
  end

  def secretary?
    self.role == "secretary" ? true : false
  end

  def longname
    "#{firstname} #{name}"
  end
end
