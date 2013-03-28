require 'spec_helper'

describe EventList do
  describe 'with validations' do
    it { should validate_presence_of(:name) }
  end
end
