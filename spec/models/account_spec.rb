require 'spec_helper'

describe Account do
  describe 'with validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
