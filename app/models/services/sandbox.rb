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
    def self.populate
      if account = ::Account.find_by_email(ENV['SANDBOX_EMAIL'])
        account.destroy
      end

      account = ::Account.create!(email: ENV['SANDBOX_EMAIL'])

      subscriber1 = account.subscribers.create!(phone_number: '15555555555')
      subscriber2 = account.subscribers.create!(phone_number: '15555555556')
      subscriber3 = account.subscribers.create!(phone_number: '15555555557')

      event_list1 = account.event_lists.create!(name: 'Event List 1')
      event_list2 = account.event_lists.create!(name: 'Event List 2')

      event1 = event_list1.events.new(name: 'Event 1', description: 'Event 1', due_at: 20.days.from_now) do |event|
        event.account = account
        event.save!
      end
      event2 = event_list1.events.new(name: 'Event 2', description: 'Event 2', due_at: 30.days.from_now) do |event|
        event.account = account
        event.save!
      end

      reminder1 = event1.reminders.create!(reminded_at: event1.due_at - 10.days)
      reminder2 = event1.reminders.create!(reminded_at: event1.due_at - 1.day)
      reminder3 = event2.reminders.create!(reminded_at: event2.due_at - 1.day)

      event_list1.subscriptions.new do |subscription|
        subscription.account = account
        subscription.subscriber = subscriber1
        subscription.save!
      end
      event_list1.subscriptions.new do |subscription|
        subscription.account = account
        subscription.subscriber = subscriber2
        subscription.save!
      end
      event_list2.subscriptions.new do |subscription|
        subscription.account = account
        subscription.subscriber = subscriber3
        subscription.save!
      end
    end
  end
end
