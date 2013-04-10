require File.expand_path('spec_fast/fast_spec_helper')
require File.expand_path('app/models/services/event_creating')

describe Services::EventCreating do
  describe '#create' do
    context 'with valid params' do
      let(:event_type) { stub(:event_type, new: new_event) }
      let(:new_event) {
        OpenStruct.new(account: nil, event_list: nil)
      }

      let(:account) { stub(:account) }
      let(:event_list) { stub(:event_list) }
      let(:params) {{
        valid: 'params',
        account: account,
        event_list: event_list
      }}
      let(:creating) { Services::EventCreating }

      it 'saves the event with the params' do
        creating.stub(:event_type) { event_type }
        new_event.should_receive(:save)
        creating.create(params)
      end

      it 'saves the event with an account' do
        creating.stub(:event_type) { event_type }
        creating.create(params)
        expect(new_event.account).to eq(account)
      end

      it 'saves the event with an event list' do
        creating.stub(:event_type) { event_type }
        creating.create(params)
        expect(new_event.event_list).to eq(event_list)
      end

      it 'returns the event' do
        creating.stub(:event_type) { event_type }
        expect(creating.create(params)).to eq(new_event)
      end
    end
  end
end
