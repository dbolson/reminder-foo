module Services
  class AccountCreating
    def self.create(params)
      account = account_type.new(params)
      if account.save
        account.create_api_key
      end
      account
    end

    private

    def self.account_type
      Account
    end
  end
end
