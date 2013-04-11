object @subscriber

extends 'api/v1/subscribers/show'

if @subscriber.errors.any?
  node :errors do |n|
    @subscriber.errors.full_messages
  end
end
