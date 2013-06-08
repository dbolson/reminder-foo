class Response < ActiveRecord::Base
  belongs_to :account

  serialize :body, JSON

  validates :account,
            :status,
            :content_type,
            :body,
            presence: true

  def self.log(params)
    account = params.delete(:account)

    response = new(params)
    response.account = account
    response.save!
    response
  end
end
