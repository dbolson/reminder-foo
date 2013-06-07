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

### A client can access:
* a list of event lists @done
* a list of events @done
  * scoped to event lists @done
* a list of subscribers @done
  * scoped to a reminder list @done
* a list of reminder dates @done
  * scoped to events @done

### curl
```
### GET#index
curl "Accept: application/json" https://localhost:3000/api/v1/event_lists -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" https://localhost:3000/api/v1/event_lists -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

### GET#show
curl "Accept: application/json" https://localhost:3000/api/v1/event_lists/1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" https://localhost:3000/api/v1/event_lists/-1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

### POST#create
curl "Accept: application/json" -X POST -d "event_list[name]=e+name" https://localhost:3000/api/v1/event_lists/ -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X POST -d "event_list[name]=" https://localhost:3000/api/v1/event_lists/ -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X POST -d "" https://localhost:3000/api/v1/event_lists/ -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

### PUT#update
curl "Accept: application/json" -X PUT -d "event_list[name]=another+name" https://localhost:3000/api/v1/event_lists/1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X PUT -d "event_list[name]=" https://localhost:3000/api/v1/event_lists/1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

### DELETE#destroy
curl "Accept: application/json" -X DELETE https://localhost:3000/api/v1/event_lists/1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X DELETE https://localhost:3000/api/v1/event_lists/-1 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
```

### events
curl "Accept: application/json" https://localhost:3000/api/v1/events -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" https://localhost:3000/api/v1/events/3 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X POST -d "event[name]=event name" -d "event[description]=event description" -d "event[due_at]=2013-06-01" https://localhost:3000/api/v1/event_lists/3/events/ -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X PUT -d "event[name]=another name" https://localhost:3000/api/v1/events/2 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X DELETE https://localhost:3000/api/v1/event_lists/3/events/2 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl "Accept: application/json" -X DELETE https://localhost:3000/api/v1/events/2 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

### reminders
curl https://localhost:3000/api/v1/events/3/reminders -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl https://localhost:3000/api/v1/events/3/reminders/3 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl -X POST -d "reminder[reminded_at]=2013-07-01" https://localhost:3000/api/v1/events/3/reminders/ -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl -X PUT -d "reminder[reminded_at]=2013-07-02" https://localhost:3000/api/v1/events/3/reminders/3 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl -X DELETE https://localhost:3000/api/v1/events/3/reminders/4 -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

## start server with ssl
thin start -p 3000 --ssl --ssl-verify --ssl-key-file ~/.ssl/server.key --ssl-cert-file ~/.ssl/server.crt

curl https://localhost:3000/api/v1/event_lists -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'
curl https://localhost:3000/api/v1/events/3/reminders -ikH 'Authorization: Token token="ee8fb0303b4066b297266c1f06a24945"'

curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists
