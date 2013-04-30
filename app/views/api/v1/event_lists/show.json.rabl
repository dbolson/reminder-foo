object false

node :event_list do |n|
  {
    id: @event_list.id,
    name: @event_list.name,
    created_at: @event_list.created_at,
    updated_at: @event_list.updated_at
  }
end
