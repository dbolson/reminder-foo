class Event < ActiveRecord::Base
  belongs_to :account
  belongs_to :event_list
  has_many :reminders, dependent: :destroy

  attr_accessible :name,
                  :description,
                  :due_at

  validates :name,
            :description,
            :due_at,
            presence: true

  validates :description,
            length: { maximum: 140 }
end
