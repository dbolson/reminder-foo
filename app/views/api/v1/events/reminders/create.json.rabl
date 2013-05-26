object @reminder

extends 'api/v1/events/reminders/show'

node false do |reminder|
  partial 'api/v1/error', object: reminder
end
