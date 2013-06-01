# Reminders API

### References
* https://app.zencoder.com/docs/api
* http://engineering.gomiso.com/2011/06/27/building-a-platform-api-on-rails/
* https://github.com/ccocchi/rabl-rails
* http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/
* https://github.com/applicake/doorkeeper

### REST Responses
* SSL
* https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453
* https://dev.twitter.com/docs/error-codes-responses
* http://stackoverflow.com/questions/7342851/catch-unknown-action-in-rails-3-for-custom-404
* https://github.com/zipmark/rspec_api_documentation

### Access Token
* can use ActionController::HttpAuthentication::Token to pass in header

### curl
```
# GET#index
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists?access_token=ee8fb0303b4066b297266c1f06a24945

# GET#show
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/1?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/event_lists/-1?access_token=ee8fb0303b4066b297266c1f06a24945

# POST
curl -i -H "Accept: application/json" -X POST -d "event_list[name]=e+name" http://localhost:3000/api/v1/event_lists/?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" -X POST -d "event_list[name]=" http://localhost:3000/api/v1/event_lists/?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" -X POST -d "" http://localhost:3000/api/v1/event_lists/?access_token=ee8fb0303b4066b297266c1f06a24945

# PUT
curl -i -H "Accept: application/json" -X PUT -d "event_list[name]=another+name" http://localhost:3000/api/v1/event_lists/1?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" -X PUT -d "event_list[name]=" http://localhost:3000/api/v1/event_lists/1?access_token=ee8fb0303b4066b297266c1f06a24945

# DELETE
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/event_lists/1?access_token=ee8fb0303b4066b297266c1f06a24945
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/event_lists/-1?access_token=ee8fb0303b4066b297266c1f06a24945
```

### A client can access:
* a list of event lists @done
* a list of events @done
  * scoped to event lists @done
* a list of subscribers @done
  * scoped to a reminder list @done
* a list of reminder dates @done
  * scoped to events @done

# show all events
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/events?access_token=ee8fb0303b4066b297266c1f06a24945
# show an event
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/events/2?access_token=ee8fb0303b4066b297266c1f06a24945
# create an event
curl -i -H "Accept: application/json" -X POST -d "event[name]=event name" -d "event[description]=event description" -d "event[due_at]=2013-06-01" http://localhost:3000/api/v1/event_lists/3/events/?access_token=ee8fb0303b4066b297266c1f06a24945
# update an event
curl -i -H "Accept: application/json" -X PUT -d "event[name]=another name" http://localhost:3000/api/v1/events/2?access_token=ee8fb0303b4066b297266c1f06a24945
# remove an event from an event list
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/event_lists/3/events/2?access_token=ee8fb0303b4066b297266c1f06a24945
# delete an event
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/events/2?access_token=ee8fb0303b4066b297266c1f06a24945

# show all reminders
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/events/3/reminders?access_token=ee8fb0303b4066b297266c1f06a24945
# show a reminder
curl -i -H "Accept: application/json" http://localhost:3000/api/v1/events/3/reminders/3?access_token=ee8fb0303b4066b297266c1f06a24945
# create a reminder
curl -i -H "Accept: application/json" -X POST -d "reminder[reminded_at]=2013-07-01" http://localhost:3000/api/v1/events/3/reminders/?access_token=ee8fb0303b4066b297266c1f06a24945
# update a reminder
curl -i -H "Accept: application/json" -X PUT -d "reminder[reminded_at]=2013-07-02" http://localhost:3000/api/v1/events/3/reminders/3?access_token=ee8fb0303b4066b297266c1f06a24945
# delete a reminder
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/api/v1/events/3/reminders/4?access_token=ee8fb0303b4066b297266c1f06a24945
