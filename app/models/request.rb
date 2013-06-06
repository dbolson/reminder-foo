class Request < ActiveRecord::Base
  belongs_to :account
  belongs_to :api_key

  serialize :params, JSON

  attr_accessible :account,
                  :api_key,
                  :ip_address,
                  :url,
                  :http_verb,
                  :params

  validates :account,
            :api_key,
            :ip_address,
            :url,
            :http_verb,
            presence: true

  before_create :filter_params

  def self.log(params)
    account = params.delete(:account)
    api_key = account.api_key

    request = new(params)
    request.account = account
    request.api_key = api_key
    request.save!
    request
  end

  private

  def filter_params
    self.params = params.reject do |k, v|
      filtered_out_params.include?(k)
    end
  end

  def filtered_out_params
    ['controller', 'action', 'access_token']
  end
end
