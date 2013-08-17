module ReminderRepresenter
  include BaseRepresenter

  property :id
  property :reminded_at, getter: ->(*) { reminded_at.to_i.to_s }
  property :updated_at
  property :created_at

  link :self do
    reminder_url(env, event_id, id)
  end
end
