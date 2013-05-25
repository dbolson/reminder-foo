object @event_list

attributes :id,
           :name,
           :created_at,
           :updated_at

node :subscribers do |event_list|
  partial 'api/v1/subscribers/subscriber', object: event_list.subscribers
end

node :subscriptions do |event_list|
  partial 'api/v1/subscriptions/subscription', object: event_list.subscriptions
end
