object @event_list

extends 'api/v1/event_lists/show'

child @event_list.subscribers do
  attributes :id,
             :phone_number,
             :created_at,
             :updated_at
end
