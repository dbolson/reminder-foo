module Services
  class SMSReminder
    def self.run
      new.notify_upcoming_reminders
      new.notify_upcoming_due_events
    end

    # Send SMS messages to subscribers of events with upcoming reminders.
    def notify_upcoming_reminders
      due_reminders.each do |reminder|
        reminder.subscribers.each do |subscriber|
          log("Sending reminder #{reminder.id} to #{subscriber.phone_number}")
          SMS::Client.send_message(phone_number: phone_number(subscriber),
                                   message: sms_message_for_reminder(reminder))
        end
      end

      nil
    end

    # Send SMS messages to subscribers of events that are due.
    def notify_upcoming_due_events
      due_events.each do |event|
        event.subscribers.each do |subscriber|
          log("Sending event #{event.id} to #{subscriber.phone_number}")
          SMS::Client.send_message(phone_number: phone_number(subscriber),
                                   message: sms_message_for_event(event))
        end
      end
    end

    private

    def log(message)
      ::Rails.logger.info(message)
    end

    def due_reminders
      Reminder.due_within_10_minutes
    end

    def due_events
      Event.due_within_10_minutes
    end

    def phone_number(subscriber)
      "+#{subscriber.phone_number}"
    end

    def sms_message_for_reminder(reminder)
      "#{reminder.event.name} is due on #{reminder.event.due_at.strftime('%m-%d')}"
    end

    def sms_message_for_event(event)
      "#{event.name} is due"
    end
  end
end
