object false

node :event_lists do |n|
  @event_lists.each do |e|
    e.id
  end
end

node :status do |n|
  @status
end
