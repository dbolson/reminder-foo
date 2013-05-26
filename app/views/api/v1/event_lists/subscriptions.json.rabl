object @event_list

extends 'api/v1/event_lists/show'

child @event_list.subscriptions do
  attributes :id,
             :created_at,
             :updated_at
end
