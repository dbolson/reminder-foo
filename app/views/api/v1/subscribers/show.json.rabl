object @subscriber

node false do |subscriber|
  partial 'api/v1/subscribers/subscriber', object: subscriber
end
