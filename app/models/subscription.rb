class Subscription < ActiveRecord::Base
  belongs_to :event_list
  belongs_to :subscriber
end
