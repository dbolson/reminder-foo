class Account < ActiveRecord::Base
  has_one :api_key,
          dependent: :destroy
  has_many :event_lists,
          dependent: :destroy
  has_many :events

  attr_accessible :email

  validates :email,
            presence: true,
            uniqueness: true,
            format: /@/
end
