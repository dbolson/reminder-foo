object @subscription

attributes :id,
           :created_at,
           :updated_at

child :event_list do
  attributes :id,
             :name,
             :created_at,
             :updated_at
end

child :subscriber do
  attributes :id,
             :phone_number,
             :created_at,
             :updated_at
end

if @subscription.errors.any?
  node :errors do |n|
    @subscription.errors.full_messages
  end
end

