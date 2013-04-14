class Subscription < ActiveRecord::Base
  belongs_to :event_list
  belongs_to :subscriber

  validates :event_list_id,
            :subscriber_id,
            presence: true

  validates :event_list_id,
            uniqueness: { scope: :subscriber_id }
end
