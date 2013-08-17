require 'spec_helper'

describe EventList do
  describe 'with relationships' do
    it { should belong_to(:account) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribers).through(:subscriptions) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:name) }

    context 'for uniqueness' do
      let!(:existing) { create(:event_list, :with_account, name: 'event list') }

      context 'for the same account' do
        it 'must have a unique name' do
          event_list = build(:event_list, account: existing.account, name: existing.name)
          expect(event_list).to_not be_valid
          expect(event_list.error_on(:name)).to eq(['has already been taken'])
        end
      end

      context 'for a different account' do
        it 'can have the same name' do
          event_list = build(:event_list, :with_account, name: existing.name)
          expect(event_list).to be_valid
        end
      end
    end
  end
end
