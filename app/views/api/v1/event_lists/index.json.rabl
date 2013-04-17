object false

@event_lists.each do |e|
  node :event_lists do |n|
    {
      id: e.id,
      name: e.name,
      created_at: e.created_at,
      updated_at: e.updated_at
    }
  end
end

node :status do |n|
  @status
end
