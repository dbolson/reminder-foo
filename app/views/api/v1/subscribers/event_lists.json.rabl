object @subscriber

extends 'api/v1/subscribers/show'

child @subscriber.event_lists do |event_list|
  extends 'api/v1/event_lists/show'
end
