object false

extends 'api/v1/event_lists/show'

if @event_list.errors.any?
  node :errors do |n|
    @event_list.errors.full_messages
  end
end
