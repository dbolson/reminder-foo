require 'spec_helper'

describe Subscription do
  describe 'with relations' do
    it { should belong_to(:event_list) }
    it { should belong_to(:subscriber) }
  end
end
