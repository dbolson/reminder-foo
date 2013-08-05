namespace :notify do
  desc 'send SMS notifications for due reminders'
  task all: :environment do
    Services::SMSReminder.run
  end
end
