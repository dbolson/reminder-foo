class EventList < ActiveRecord::Base
  belongs_to :account
  has_many :events,
           dependent: :destroy
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions

  attr_accessible :name

  validates :name, presence: true

  scope :ordered, order('event_lists.created_at DESC')
end
