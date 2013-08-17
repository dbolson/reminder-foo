module EventRepresenter
  include BaseRepresenter

  property :id
  property :name
  property :description
  property :due_at, getter: ->(*) { due_at.to_i.to_s }
  property :updated_at
  property :created_at

  link :self do
    event_url(env, event_list_id, id)
  end
end
