class Track < ActiveRecord::Base
  # RELATIONSHIPS
  belongs_to :user
  belongs_to :event

  # SCOPED
  default_scope { order('created_at ASC')}
end
