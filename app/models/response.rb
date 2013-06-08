class Response < ActiveRecord::Base
  belongs_to :account

  serialize :body, JSON

  validates :status,
            :content_type,
            :body,
            presence: true

  def self.log(params)
    create(params)
  end
end
