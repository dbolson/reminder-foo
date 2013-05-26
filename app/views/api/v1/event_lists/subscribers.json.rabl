object @event_list

extends 'api/v1/event_lists/show'

child @event_list.subscribers do |subscriber|
  extends 'api/v1/subscribers/show'
end
