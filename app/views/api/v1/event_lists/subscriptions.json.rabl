object @event_list

extends 'api/v1/event_lists/show'

child @event_list.subscriptions do |subscription|
  extends 'api/v1/subscriptions/subscription'
end
