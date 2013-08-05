class Event < ActiveRecord::Base
  belongs_to :account
  belongs_to :event_list
  has_many :reminders, dependent: :destroy
  has_many :subscribers, through: :event_list

  validates :name,
            :description,
            :due_at,
            presence: true

  validates :description,
            length: { maximum: 140 }

  scope :due_within_10_minutes, -> { where(due_at: 10.minutes.ago..Time.zone.now) }
end
