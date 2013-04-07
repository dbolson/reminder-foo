class EventList < ActiveRecord::Base
  belongs_to :account
  has_many :events,
           dependent: :destroy

  attr_accessible :name

  validates :name, presence: true
end
