require_relative '../../lib/decorator'

describe Decorator do
  class FakeDecorator
    include Decorator
  end

  class FakeDecorated
    def my_method; 'my method'; end
  end

  it 'delegates all methods to the underlying object' do
    expect(FakeDecorator.new(FakeDecorated.new).my_method).to eq('my method')
  end

  it 'delegates the class to the underlying object' do
    expect(FakeDecorator.new(FakeDecorated.new).class).to eq(FakeDecorated)
  end
end
