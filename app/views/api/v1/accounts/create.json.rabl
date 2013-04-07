object @account

extends 'api/v1/accounts/show'

if @account.errors.any?
  node :errors do |n|
    @account.errors.full_messages
  end
end
