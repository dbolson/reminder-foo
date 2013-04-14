object @reminder

extends 'api/v1/events/reminders/show'

if @reminder.errors.any?
  node :errors do |n|
    @reminder.errors.full_messages
  end
end
