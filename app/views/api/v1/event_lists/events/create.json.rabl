object @event

extends 'api/v1/events/show'

node false do |event|
  partial 'api/v1/error', object: event
end
