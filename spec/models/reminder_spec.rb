require 'spec_helper'

describe Reminder do
  describe 'with relationships' do
    it { should belong_to(:event) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:reminded_at) }

    it 'must have a unique phone number' do
      existing = FactoryGirl.create(:reminder_with_event)
      new_record = FactoryGirl.build(:reminder_with_event,
                                     event: existing.event,
                                     reminded_at: existing.reminded_at)
      new_record.should_not be_valid
      new_record.errors[:reminded_at].should_not be_empty
    end

    it 'cannot be in the past' do
      record = FactoryGirl.build(:reminder, reminded_at: 1.day.ago)
      record.valid?
      record.errors[:reminded_at].should_not be_empty
    end

    it 'can be today' do
      record = FactoryGirl.build(:reminder, reminded_at: Time.zone.now)
      record.valid?
      record.errors[:reminded_at].should be_empty
    end
  end
end
