object @subscriber

node false do |subscriber|
  partial 'api/v1/subscribers/subscriber', object: subscriber
end

node :event_lists do |subscriber|
  partial 'api/v1/event_lists/event_list', object: subscriber.event_lists
end
