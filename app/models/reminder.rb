class Reminder < ActiveRecord::Base
  belongs_to :event

  validates :reminded_at,
            presence: true,
            uniqueness: { scope: :event_id }

  attr_accessible :reminded_at

  validate :not_in_past

  private

  def not_in_past
    if reminded_at && reminded_at < Time.zone.now.beginning_of_day
      errors.add(:reminded_at, 'cannot be in the past')
    end
  end
end
