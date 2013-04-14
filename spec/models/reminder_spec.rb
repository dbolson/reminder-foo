require 'spec_helper'

describe Reminder do
  describe 'with relationships' do
    it { should belong_to(:event) }
  end

  describe 'with validations' do
    before do
      now = Time.parse('Jan 01 2000')
      Time.stub!(:now) { now }
    end

    it { should validate_presence_of(:reminded_at) }
    it { should_not allow_value('bad date').for(:reminded_at) }
    it { should_not allow_value('2000-01-32').for(:reminded_at) }
    it { should allow_value('2000-01-02').for(:reminded_at) }
    it { should allow_value('2000-01-02 00:01:01').for(:reminded_at) }

    it 'must have a unique reminded at date for an event' do
      existing = FactoryGirl.create(:reminder_with_event)
      new_record = FactoryGirl.build(:reminder_with_event,
                                     event: existing.event,
                                     reminded_at: existing.reminded_at)
      new_record.should_not be_valid
      expect(new_record.errors[:reminded_at]).to_not be_empty
    end

    it 'can be today' do
      record = FactoryGirl.build(:reminder, reminded_at: Time.zone.now)
      record.valid?
      expect(record.errors[:reminded_at]).to be_empty
    end

    it 'cannot be in the past' do
      record = FactoryGirl.build(:reminder, reminded_at: 1.day.ago)
      record.valid?
      expect(record.errors[:reminded_at]).to_not be_empty
    end

    it 'displays an error message for an invalid time' do
      record = FactoryGirl.build(:reminder, reminded_at: 'Jan 34 2000')
      record.valid?
      expect(record.errors[:reminded_at].count).to eq(1)
      expect(record.errors[:reminded_at][0]).to match('is an invalid date')
    end
  end
end
