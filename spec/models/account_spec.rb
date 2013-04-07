require 'spec_helper'

describe Account do
  describe 'with relationships' do
    it { should have_one(:api_key) }
    it { should have_many(:event_lists) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
