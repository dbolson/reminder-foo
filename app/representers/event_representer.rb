module EventRepresenter
  include BaseRepresenter

  property :id
  property :name
  property :description
  property :due_at
  property :updated_at
  property :created_at

  link :self do
    event_url(env, event_list_id, id)
  end
end
