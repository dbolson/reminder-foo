object @subscriber

extends 'api/v1/subscribers/show'

node false do |subscriber|
  partial 'api/v1/error', object: subscriber
end
