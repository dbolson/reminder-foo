object @account

extends 'api/v1/accounts/show'

node false do |account|
  partial 'api/v1/error', object: account
end
