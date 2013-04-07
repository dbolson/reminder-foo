require 'spec_helper'

describe Account do
  describe 'with relationships' do
    it { should have_one(:api_key).dependent(:destroy) }
    it { should have_many(:event_lists).dependent(:destroy) }
  end

  describe 'with validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should_not allow_value('bad_email').for(:email) }
    it { should allow_value('a@b.com').for(:email) }
  end
end
