require_relative '../fast_spec_helper'
require_relative '../../lib/decorator'
require_relative '../../app/decorators/api_resource'

describe APIResource do
  class FakeDecorated
    def created_at; Time.now; end
    def updated_at; Time.now; end
    def my_method; 'my method'; end
  end

  before do
    Timecop.freeze(Time.local(2000, 1, 1))
  end

  describe '#created_at' do
    it 'displays the date in unix ' do
      expect(APIResource.new(FakeDecorated.new).created_at).to eq('946713600')
    end
  end

  describe '#updated_at' do
    it 'displays the date in unix ' do
      expect(APIResource.new(FakeDecorated.new).updated_at).to eq('946713600')
    end
  end

  it 'delegates other methods to the underlying object' do
      expect(APIResource.new(FakeDecorated.new).my_method).to eq('my method')
  end
end
