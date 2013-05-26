object @event_list

node false do |event_list|
  partial 'api/v1/event_lists/event_list', object: event_list
end
