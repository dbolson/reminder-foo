object @subscriber

attributes :id,
           :phone_number,
           :created_at,
           :updated_at

node do |n|
  { event_lists: partial('api/v1/event_lists/show', object: n.event_lists) }
end
