require 'spec_helper'

describe Subscriber do
  describe 'with relationships' do
    it { should belong_to(:account) }
    it { should have_many(:subscriptions) }
    it { should have_many(:event_lists).through(:subscriptions) }
  end

  describe 'with validations' do
    specify do
      existing = FactoryGirl.create(:subscriber_with_account)
      new_record = FactoryGirl.build(:subscriber_with_account,
                                     phone_number: existing.phone_number)
      new_record.should_not be_valid
      new_record.errors[:phone_number].should_not be_empty
    end

    it { should validate_presence_of(:phone_number) }

    context 'for a formatted phone number' do
      it { should allow_value('5555555555').for(:phone_number) }
      it { should allow_value('15555555555').for(:phone_number) }
      it { should_not allow_value('fake number').for(:phone_number) }
      it { should_not allow_value('555-555').for(:phone_number) }
      it { should_not allow_value('555-555-555').for(:phone_number) }
      it { should_not allow_value('1-555-555-55555').for(:phone_number) }
      it { should_not allow_value('155555555555').for(:phone_number) }

      it 'only displays one error when empty' do
        record = FactoryGirl.build(:subscriber, phone_number: '')
        record.valid?
        record.errors.size.should == 1
        record.errors.full_messages.should == ["Phone number can't be blank"]
      end
    end
  end

  describe 'when saving' do
    it 'adds area code with none' do
      record = FactoryGirl.create(:subscriber_with_account,
                                  phone_number: '5555555555')
      record.phone_number.should == '15555555555'
    end

    it 'keeps the area code with one present' do
      record = FactoryGirl.create(:subscriber_with_account,
                                  phone_number: '15555555555')
      record.phone_number.should == '15555555555'
    end

    it 'removes non-numeric characters' do
      invalid_phone_numbers = [
        '+15555555555',
        '1 (555) 555-5555',
        '1-555-555-5555',
        '1 555 555 5555',
        '1/555/555/5555',
        '1.555.555.5555'
      ]

      invalid_phone_numbers.each do |phone_number|
        record = FactoryGirl.create(:subscriber_with_account,
                                    phone_number: phone_number)
        record.phone_number.should == '15555555555'
      end
    end
  end
end
