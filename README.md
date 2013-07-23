# ReminderFoo

ReminderFoo is a RESTful SaaS application to send custom SMS reminders to specified phone numbers.

## Domain Model

### EventList

- Has a list of events
- Subscribers subscribe to an event list to receive reminders of all events in the list

### Event

- Has a list of reminders
- This is what is sent to a subscriber as a reminder
- Contained within an event list

### Reminder

- Contained within an event
- Each reminder is the date when an event should be sent to a subscriber

### Subscriber

- A user, based on his phone number, who receives reminders
- Subscribed to an event list

### Subscription

- Ties a subscriber to an event list

### Account

- The person or application signed up with ReminderFoo

### APIKey

- Allows access to make all API calls
- Contains the access token

## Making API Calls Using cURL

- -k for SSL
- -u for basic authentication
- basic auth: username is API key with no password
- Responses are always in JSON

### GET
`curl -ku {api key}: https://localhost:3000/api/v1/{resource}/{id}`

### POST
`curl -ku {api key}: -X POST -d "{field}={value}" https://localhost:3000/api/v1/{resource}

### PUT
`curl -ku {api key}: -X PUT -d "{field}={value}" https://localhost:3000/api/v1/{resource}/{id}

### DELETE
`curl -ku {api key}: -X DELETE https://localhost:3000/api/v1/{resource}/{id}`

## TODO

* add uuid field
  * explore rails 4 for uuid primary key field
  * create separate field to eventually phase out current id
* change due_at to be a date type
* pagination
* versioning
  * slide 11
  * http://www.slideshare.net/dblockdotorg/building-restful-apis-w-grape
* add more API information with kramdown

## Commands

### Start server with ssl
thin start -p 3000 --ssl --ssl-verify --ssl-key-file ~/.ssl/server.key --ssl-cert-file ~/.ssl/server.crt

### Tasks
```
rake sandbox:populate
```
