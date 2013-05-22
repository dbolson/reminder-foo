class Account < ActiveRecord::Base
  has_one :api_key,
          dependent: :destroy
  has_many :event_lists,
          dependent: :destroy
  has_many :events
  has_many :subscribers,
           dependent: :destroy
  has_many :subscriptions,
           dependent: :destroy

  attr_accessible :email

  validates :email,
            presence: true,
            uniqueness: true,
            format: /\A.+@.+\z/

  def ordered_event_lists
    event_lists.ordered.all
  end
end
