module API
  class Accounts < BaseV1
    before do
      authenticate!
    end

    # GET show
    desc 'Get account information', {
      http_codes: {
        200 => 'Account found',
        401 => 'Unauthorized access',
        404 => 'Invalid account'
      }
    }

    get '/accounts' do
      represent(current_account)
    end
  end
end
