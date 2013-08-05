class SMSReminder
  def self.run
    new.notify_upcoming_reminders
    new.notify_upcoming_due_events
  end

  # Send SMS messages to subscribers of events with upcoming reminders.
  def notify_upcoming_reminders
    reminders.each do |reminder|
      reminder.subscribers.each do |subscriber|
        SMS::Client.send_message(phone_number: phone_number(subscriber),
                                 message: sms_message(reminder))
      end
    end

    nil
  end

  # Send SMS messages to subscribers of events that are due.
  def notify_upcoming_due_events
    # get list of events to send
    # get list of subscribers for those events
    #   event.event_list.subscribers
    # send sms to each subscriber
  end

  private

  def reminders
    @_reminders ||= Reminder.due_within_10_minutes
  end

  def phone_number(subscriber)
    "+#{subscriber.phone_number}"
  end

  def sms_message(reminder)
    "#{reminder.event.name} is due on #{reminder.event.due_at.strftime('%m-%d')}"
  end
end
