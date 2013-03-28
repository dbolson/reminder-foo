# Reminders API

### References
* https://app.zencoder.com/docs/api
* http://engineering.gomiso.com/2011/06/27/building-a-platform-api-on-rails/
* https://github.com/ccocchi/rabl-rails
* http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/
* https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453

### A client can access:
* a list of event lists
* a list of events
  * scoped to event lists
* a list of reminder dates
  * scoped to events
* a list of subscribers
    * scoped to a reminder list

```
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

    class SubscribersController
    end

    class EventLists::SubscribersController
    end
  end
end
```

### API DOC
```
describe 'index' do
  it 'returns a list of questions', :api_doc => true do
    get :index
    response.status.should be(200)
  end
end

rake api:doc
```

go to /api_docs
