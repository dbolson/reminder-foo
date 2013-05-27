object @subscriber

extends 'api/v1/subscribers/show'

child @subscriber.subscriptions do |subscription|
  extends 'api/v1/subscriptions/subscription'
end
