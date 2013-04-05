require 'spec_helper'

describe ApiKey do
  describe 'with validations' do
    it { should validate_uniqueness_of(:access_token) }
  end

  describe 'when creating' do
    it 'generates an access token' do
      record = FactoryGirl.create(:api_key, access_token: nil)
      record.access_token.should be_present
    end
  end
end
