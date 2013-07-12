module EventListRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include BaseRepresenter

  property :id
  property :name
  property :updated_at
  property :created_at

  link :self do
    event_list_url(env, id)
  end
end
