class Track < ActiveRecord::Base
  # RELATIONSHIPS
  belongs_to :user
  belongs_to :event
end
