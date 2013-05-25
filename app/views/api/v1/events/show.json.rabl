object @event

attributes :id,
           :name,
           :description,
           :due_at,
           :created_at,
           :updated_at

node do |n|
  {
    event_list: partial('api/v1/event_lists/event_list', object: n.event_list)
  }
end
