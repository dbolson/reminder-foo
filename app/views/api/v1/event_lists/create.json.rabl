object @event_list

extends 'api/v1/event_lists/show'

node false do |event_list|
  partial 'api/v1/error', object: event_list
end
