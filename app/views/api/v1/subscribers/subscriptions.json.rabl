object @subscriber

extends 'api/v1/subscribers/show'

child @subscriber.subscriptions do
  attributes :id,
             :created_at,
             :updated_at
end
