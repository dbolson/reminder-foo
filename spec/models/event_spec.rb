require 'spec_helper'

describe Event do
  describe 'with relationships' do
    it { should belong_to(:account) }
    it { should belong_to(:event_list) }
    it { should have_many(:reminders) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should allow_value('a' * 140).for(:description) }
    it { should_not allow_value('a' * 141).for(:description) }
    it { should validate_presence_of(:due_at) }
  end
end
