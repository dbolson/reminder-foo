class EventList < ActiveRecord::Base
  belongs_to :account
  has_many :events, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions

  validates :name, presence: true, uniqueness: { scope: :account_id }

  scope :ordered, order('event_lists.created_at DESC')
end
