module SubscriptionRepresenter
  include BaseRepresenter

  property :id
  property :updated_at
  property :created_at

  link :self do
    subscription_url(env, id)
  end
end
