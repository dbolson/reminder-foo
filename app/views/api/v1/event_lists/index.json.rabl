object false

node :event_lists do |n|
  @event_lists.map do |e|
    {
      event_list: {
        id: e.id,
        name: e.name,
        created_at: e.created_at,
        updated_at: e.updated_at
      }
    }
  end
end
