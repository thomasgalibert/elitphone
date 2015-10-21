class User < ActiveRecord::Base
  has_secure_password

  # Validations
  validates_presence_of :password, on: :create, length: { minimum: 8 }
  validates_presence_of :email
  validates_presence_of :name
  validates_presence_of :firstname
  validates_uniqueness_of :email
  validates :email, email: true

  # Relationships
  belongs_to :company, optional: true

  # Callbacks
  before_save :check_is_admin?

  # Check if admin user exists for this company, if not
  # creates one
  def check_is_admin?
    if self.company.users.where(role: "admin").count == 0
      self.role = "admin"
    end
  end
end
