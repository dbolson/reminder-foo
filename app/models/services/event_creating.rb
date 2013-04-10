module Services
  class EventCreating
    def self.create(params)
      account = params.delete(:account)
      event_list = params.delete(:event_list)

      event = event_type.new(params)
      event.account = account
      event.event_list = event_list
      event.save
      event
    end

    private

    def self.event_type
      Event
    end
  end
end
