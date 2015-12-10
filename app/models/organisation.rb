class Organisation < ActiveRecord::Base
  # RELATIONSHIPS
  belongs_to :company
  belongs_to :user

  has_many :participations, dependent: :destroy
  has_many :users, through: :participations

  # VALIDATIONS
  validates :name, :company_id, :user_id, presence: true

  # METHODS
  def owner
    self.user.longname
  end
end
