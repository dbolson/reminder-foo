class Reminder < ActiveRecord::Base
  belongs_to :event

  validates :reminded_at,
            presence: true,
            uniqueness: { scope: :event_id }

  attr_accessible :reminded_at
end
