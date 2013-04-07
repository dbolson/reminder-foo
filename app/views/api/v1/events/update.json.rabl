object @event

extends 'api/v1/events/show'

if @event.errors.any?
  node :errors do |n|
    @event.errors.full_messages
  end
end
