object @reminder

attributes :id,
           :reminded_at,
           :created_at,
           :updated_at

node :event do |reminder|
  partial 'api/v1/events/event', object: reminder.event
end
