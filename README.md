# Reminders API

### References
* https://app.zencoder.com/docs/api
* http://engineering.gomiso.com/2011/06/27/building-a-platform-api-on-rails/
* https://github.com/ccocchi/rabl-rails
* http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/

### REST Responses
* include status code
* include error messages
* include hyperlinks to help for errors
* https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453
* https://dev.twitter.com/docs/error-codes-responses
* http://stackoverflow.com/questions/7342851/catch-unknown-action-in-rails-3-for-custom-404

### curl
```
# GET
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/1
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/-1

# POST
curl -i -H "Accept: application/json" -X POST -d "event_list[name]=e+name" http://localhost:3000/api/v1/event_lists/
curl -i -H "Accept: application/json" -X POST -d "event_list[name]=" http://localhost:3000/api/v1/event_lists/
curl -i -H "Accept: application/json" -X POST -d "" http://localhost:3000/api/v1/event_lists/

# PUT
curl -i -H "Accept: application/json" -X PUT -d "event_list[name]=another+name" http://localhost:3000/api/v1/event_lists/1
curl -i -H "Accept: application/json" -X PUT -d "event_list[name]=" http://localhost:3000/api/v1/event_lists/1

# DELETE
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/event_lists/1
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/event_lists/-1
```

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
