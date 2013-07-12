module SubscriberRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include BaseRepresenter

  property :id
  property :phone_number
  property :updated_at
  property :created_at

  link :self do
    subscriber_url(env, id)
  end
end
