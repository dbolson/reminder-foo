require 'spec_helper'

describe Subscriber do
  describe 'with relationships' do
    it { should belong_to(:account) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:phone_number) }
  end
end
