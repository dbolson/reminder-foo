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
end
