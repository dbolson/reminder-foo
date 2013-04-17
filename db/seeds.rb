admin = Account.create!(email: 'test@test.com')
admin.create_api_key

event_list = admin.event_lists.create(name: 'list 1')

event = event_list.events.build(name: 'event 1',
                                description: 'event 1 for list 1',
                                due_at: 10.days.from_now)
event.account = admin
event.save!

event.reminders.create(reminded_at: 5.days.from_now)

subscriber = event_list.subscribers.build(phone_number: '15555555555')
subscriber.account = admin
subscriber.save!

subscription = subscriber.subscriptions.build
subscription.event_list = event_list
subscription.save!
