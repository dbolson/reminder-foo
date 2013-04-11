class Subscriber < ActiveRecord::Base
  belongs_to :account

  attr_accessible :phone_number

  validates :phone_number, presence: true
end
