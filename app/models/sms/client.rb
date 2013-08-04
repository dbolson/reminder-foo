module SMS
  class Client
    class InvalidArgumentError < StandardError; end

    attr_accessor :sms_client

    def self.create_message(args={})
      new.create_message(args)
    end

    def create_message(args={})
      ensure_valid_phone_number!(args)
      ensure_valid_message!(args)

      sms_client.account.sms.messages.create(message_args(args))
    end

    def list
      sms_client.account.sms.messages.list
    end

    def sms_client
      @sms_client ||= Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    end

    private

    def ensure_valid_phone_number!(args)
      if args[:phone_number].nil? || !(args[:phone_number] =~ /\+1\d{10}/)
        raise InvalidArgumentError.new('Please provide a phone number in the form +15555555555')
      end
    end

    def ensure_valid_message!(args)
      raise InvalidArgumentError.new('Please provide a message') if args[:message].nil?
    end

    def message_args(args)
      {
        from: admin_phone_number,
        to: args[:phone_number],
        body: args[:message]
      }
    end

    def admin_phone_number
      ENV['TWILIO_ADMIN_PHONE_NUMBER']
    end
  end
end
