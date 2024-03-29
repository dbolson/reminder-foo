require 'spec_helper'

describe Account do
  describe 'with relationships' do
    it { should have_one(:api_key).dependent(:destroy) }
    it { should have_many(:event_lists).dependent(:destroy) }
    it { should have_many(:events) }
    it { should have_many(:subscribers).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should_not allow_value('bad_email').for(:email) }
    it { should_not allow_value("\nbad@email.com").for(:email) }
    it { should allow_value('a@b.com').for(:email) }
  end

  describe '#ordered_event_lists' do
    it 'finds the sorted event lists' do
      account = create(:account)
      event_list1 = create(:event_list, account: account,
                           created_at: 1.day.ago)
      event_list2 = create(:event_list, account: account,
                           created_at: Time.now)
      expect(account.ordered_event_lists).to eq([event_list2, event_list1])
    end
  end
end
