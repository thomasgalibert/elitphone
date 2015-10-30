class Company < ActiveRecord::Base
  # Validations
    validates :email, :name, :number, presence: true
    validates_uniqueness_of :email
    validates :email, email: true
    validates :cgv, presence: true

    validates_format_of :tel, :with => /[0,0][1-9]\s(\d{2}\s)*\d{2}/


    # Relationships
    has_many :users, autosave: true
    accepts_nested_attributes_for :users
    has_many :agendas
end
