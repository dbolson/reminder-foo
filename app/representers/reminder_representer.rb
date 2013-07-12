module ReminderRepresenter
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include BaseRepresenter

  property :id
  property :reminded_at
  property :updated_at
  property :created_at

  link :self do
    reminder_url(env, event_id, id)
  end
end
