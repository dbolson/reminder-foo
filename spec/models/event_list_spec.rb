require 'spec_helper'

describe EventList do
  describe 'with relationships' do
    it { should belong_to(:account) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:subscriptions) }
    it { should have_many(:subscribers).through(:subscriptions) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:name) }
  end
end
