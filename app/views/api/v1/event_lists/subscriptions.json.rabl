object @event_list

attributes :id,
           :name,
           :created_at,
           :updated_at

child @event_list.subscriptions do
  attributes :id,
             :created_at,
             :updated_at
end
