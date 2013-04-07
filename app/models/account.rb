class Account < ActiveRecord::Base
  has_one :api_key
  has_many :event_lists

  attr_accessible :email

  validates :email,
            presence: true,
            uniqueness: true
end
