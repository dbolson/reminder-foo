class ApiKey < ActiveRecord::Base
  belongs_to :account

  attr_accessible :access_token

  validates :access_token,
            uniqueness: true

  before_create :generate_access_token

  private

  def generate_access_token
    begin
      write_attribute(:access_token, SecureRandom.hex)
    end while self.class.exists?(access_token: access_token)
  end
end
