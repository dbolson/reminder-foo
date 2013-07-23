# account
#   event_list
#     event
#       reminder
#       reminder
#     event
#       reminder
#     subscriber
#     subscriber
#   event_list
#     subscriber

module Services
  class Sandbox
    def self.populate!
      new.populate!
    end

    def populate!
      event_lists = create_event_lists_for!(account)
      events = create_events_for(event_lists)
      create_reminders_for!(events)
      subscribers = create_subscribers_for!(account)
      create_subscriptions_for!(event_lists, subscribers)
      nil
    end

    private

    def account
      @_account ||= create_account!
    end

    def create_account!
      ensure_one_account
      Services::AccountCreating.create(email: ENV['SANDBOX_EMAIL'])
    end

    def ensure_one_account
      if account = ::Account.find_by_email(ENV['SANDBOX_EMAIL'])
        account.destroy
      end
    end

    def create_subscribers_for!(account)
      [
        account.subscribers.create!(phone_number: '15555555555'),
        account.subscribers.create!(phone_number: '15555555556'),
        account.subscribers.create!(phone_number: '15555555557')
      ]
    end

    def create_event_lists_for!(account)
      [
        account.event_lists.create!(name: 'Event List 1'),
        account.event_lists.create!(name: 'Event List 2')

      ]
    end

    def create_events_for(event_lists)
      [
        event_lists[0].events.new { |event|
          event.name = 'Event 1'
          event.description = 'Event 1'
          event.due_at = 20.days.from_now
          event.account = account
          event.save!
        },
        event_lists[0].events.new { |event|
          event.name = 'Event 2'
          event.description = 'Event 2'
          event.due_at = 30.days.from_now
          event.account = account
          event.save!
        }
      ]
    end

    def create_reminders_for!(events)
      [
        events[0].reminders.create!(reminded_at: events[0].due_at - 10.days),
        events[0].reminders.create!(reminded_at: events[0].due_at - 1.day),
        events[1].reminders.create!(reminded_at: events[1].due_at - 1.day)
      ]
    end

    def create_subscriptions_for!(event_lists, subscribers)
      [
        event_lists[0].subscriptions.new { |subscription|
          subscription.account = account
          subscription.subscriber = subscribers[0]
          subscription.save!
        },
        event_lists[0].subscriptions.new { |subscription|
          subscription.account = account
          subscription.subscriber = subscribers[1]
          subscription.save!
        },
        event_lists[1].subscriptions.new { |subscription|
          subscription.account = account
          subscription.subscriber = subscribers[2]
          subscription.save!
        }
      ]
    end
  end
end
