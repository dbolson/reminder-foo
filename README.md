# Reminders API

event_lists
  events
    reminder_dates

A client can access:

a list of event lists
a list of events
  scoped to event lists
a list of reminder dates
  scoped to events

Module Api
  module V1
    class EventListsController
    end

    class EventsController
    end

    class ReminderDatesController
    end

    class EventLists::EventsController
    end

    class Events::ReminderDatesController
    end
  end
end

API DOC
describe 'index' do
  it 'returns a list of questions', :api_doc => true do
    get :index
    response.status.should be(200)
  end
end
rake api:doc
go to /api_docs
