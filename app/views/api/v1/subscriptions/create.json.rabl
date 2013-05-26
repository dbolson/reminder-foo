object @subscription

attributes :id,
           :created_at,
           :updated_at

child :event_list do
  extends 'api/v1/event_lists/show'
end

child :subscriber do
  extends 'api/v1/subscribers/show'
end

node false do |subscription|
  partial 'api/v1/error', object: subscription
end
