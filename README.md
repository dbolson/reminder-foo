# Reminders API

### References
* https://app.zencoder.com/docs/api
* http://engineering.gomiso.com/2011/06/27/building-a-platform-api-on-rails/
* http://blogs.plexibus.com/2009/01/15/rest-esting-with-curl/
* https://github.com/applicake/doorkeeper

### REST Responses
* https://github.com/rack/rack/blob/master/lib/rack/utils.rb#L453
* https://dev.twitter.com/docs/error-codes-responses
* http://stackoverflow.com/questions/7342851/catch-unknown-action-in-rails-3-for-custom-404

### A client can access:
* a list of event lists @done
* a list of events @done
  * scoped to event lists @done
* a list of subscribers @done
  * scoped to a reminder list @done
* a list of reminder dates @done
  * scoped to events @done

# TODO

https://github.com/cutalion/grape-api-example
http://petstore.swagger.wordnik.com/

* set up namespace @done
* set versioning @done
* set up representation of event list @done
  * roar gem @done
  * only expose certain fields @done
* expose all verbs for event list @done
* manually add swagger ui @done
* set up authorization @done
* add hypermedia links to responses @done
* add uuid field
  * explore rails 4 for uuid primary key field
  * create separate field to eventually phase out current id
* create sandbox account
  * own api key
  * task to regenerate data
* finish swagger data
  * show status codes @done
  * show field details
* change due_at to be a date type

* pagination
* versioning
  * slide 11
  * http://www.slideshare.net/dblockdotorg/building-restful-apis-w-grape

curl -X DELETE http://localhost:3000/api/v1/event_lists/9

/event_lists @done
/event_lists/1/events @done
/events @done
/events/1/reminders @done

/subscribers
  index
  show
  create
  update
  destroy

/subscribers/1/event_lists
/subscribers/1/subscriptions?

/subscriptions?

/accounts
  show

### curl
```
### GET#index
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists

### GET#show
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists/1
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists/-1

### POST#create
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X POST -d "event_list[name]=e+name" https://localhost:3000/api/v1/event_lists/
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X POST -d "event_list[name]=" https://localhost:3000/api/v1/event_lists/
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X POST -d "" https://localhost:3000/api/v1/event_lists/

### PUT#update
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event_list[name]=another+name" https://localhost:3000/api/v1/event_lists/1
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event_list[name]=" https://localhost:3000/api/v1/event_lists/1

### DELETE#destroy
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X DELETE https://localhost:3000/api/v1/event_lists/1
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X DELETE https://localhost:3000/api/v1/event_lists/-1
```

### events
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/events
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/events/3
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X POST -d "event[name]=event name" -d "event[description]=event description" -d "event[due_at]=2013-06-01" https://localhost:3000/api/v1/event_lists/3/events/
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event[name]=another name" https://localhost:3000/api/v1/events/2
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X DELETE https://localhost:3000/api/v1/event_lists/3/events/2
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X DELETE https://localhost:3000/api/v1/events/2

### reminders
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/events/3/reminders
curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/events/3/reminders/3
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X POST -d "reminder[reminded_at]=2013-07-01" https://localhost:3000/api/v1/events/3/reminders/
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "reminder[reminded_at]=2013-07-02" https://localhost:3000/api/v1/events/3/reminders/3
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X DELETE https://localhost:3000/api/v1/events/3/reminders/4

## start server with ssl
thin start -p 3000 --ssl --ssl-verify --ssl-key-file ~/.ssl/server.key --ssl-cert-file ~/.ssl/server.crt

curl -kiu ee8fb0303b4066b297266c1f06a24945: https://localhost:3000/api/v1/event_lists
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event[name]=another name" https://localhost:3000/api/v1/events/3
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event[name]=another name" https://localhost:3000/api/v1/events/3

### this will not update the event list
curl -kiu ee8fb0303b4066b297266c1f06a24945: -X PUT -d "event[name]=another name" -d "event[event_list_id]=4" https://localhost:3000/api/v1/events/3

### can send data as json
curl -kiu ee8fb0303b4066b297266c1f06a24945: -H "Content-type: application/json" -X PUT -d '{"event":{"name":"foobar"}}' https://localhost:3000/api/v1/events/3
