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

  # Computed methods

  def longname
    "#{firstname} #{name}"
  end
end
