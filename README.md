# Reminders API

### References
* https://app.zencoder.com/docs/api
* http://engineering.gomiso.com/2011/06/27/building-a-platform-api-on-rails/
* https://github.com/ccocchi/rabl-rails
* http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/
* https://github.com/applicake/doorkeeper

### REST Responses
* SSL
* include status code
* include error messages
* include hyperlinks to help for errors
* https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453
* https://dev.twitter.com/docs/error-codes-responses
* http://stackoverflow.com/questions/7342851/catch-unknown-action-in-rails-3-for-custom-404
* https://github.com/zipmark/rspec_api_documentation

### Access Token
* can use ActionController::HttpAuthentication::Token to pass in header

### curl
```
# GET
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
* a list of reminder dates
  * scoped to events
* a list of subscribers
  * scoped to a reminder list
