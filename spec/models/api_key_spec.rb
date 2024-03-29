require 'spec_helper'

describe APIKey do
  describe 'with relationships' do
    it { should belong_to(:account) }
  end

  describe 'with validations' do
    it 'must be unique' do
      record = create(:api_key)
      expect(record).to validate_uniqueness_of(:access_token)
    end
  end

  describe 'when creating' do
    it 'generates an access token' do
      record = create(:api_key, access_token: nil)
      expect(record.access_token).to be_present
    end
  end
end
