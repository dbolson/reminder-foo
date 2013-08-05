class Reminder < ActiveRecord::Base
  belongs_to :event

  validates :reminded_at,
            presence: true,
            uniqueness: { scope: :event_id }

  validate :not_in_past
  validate :with_correct_format

  scope :due_within_10_minutes, -> { where(reminded_at: 10.minutes.ago..Time.zone.now) }

  delegate :subscribers, to: :event

  private

  def with_correct_format
    if reminded_at.nil? && reminded_at_before_type_cast.present?
      errors.delete(:reminded_at)
      errors.add(:reminded_at,
                 "#{reminded_at_before_type_cast} is an invalid date")
    end
  end

  def not_in_past
    if reminded_at && reminded_at < Time.zone.now.beginning_of_day
      errors.add(:reminded_at, 'cannot be in the past')
    end
  end
end
