object @subscriber

attributes :id,
           :phone_number,
           :created_at,
           :updated_at

node :event_lists do |subscriber|
  partial 'api/v1/event_lists/show', object: subscriber.event_lists
end

node :subscriptions do |subscriber|
  partial 'api/v1/subscriptions/subscription', object: subscriber.subscriptions
end
