class EventList < ActiveRecord::Base
  belongs_to :account

  attr_accessible :name

  validates :name, presence: true
end
