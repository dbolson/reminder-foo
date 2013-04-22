require 'spec_helper'

describe Subscription do
  describe 'with relations' do
    it { should belong_to(:event_list) }
    it { should belong_to(:subscriber) }
  end

  describe 'with validations' do
    specify do
      existing = create(:subscription_with_associations)
      new_record = build(:subscription_with_associations,
                         event_list: existing.event_list,
                         subscriber: existing.subscriber)
      new_record.should_not be_valid
      new_record.errors[:event_list_id].should_not be_empty
    end

    it { should validate_presence_of(:event_list_id) }
    it { should validate_presence_of(:subscriber_id) }
  end
end
