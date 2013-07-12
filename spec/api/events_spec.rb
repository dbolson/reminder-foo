require 'spec_helper'

describe API::Events do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  before do
    Timecop.freeze(2000, 1, 1)
  end

  after do
    Timecop.return
  end

  describe 'GET index' do
    let(:verb) { :get }
    let(:path) { '/api/v1/events' }
    let(:params) {{}}

    let!(:event1) { create(:event, :with_event_list, account: account) }
    let!(:event2) { create(:event, :with_event_list, account: account) }
    let!(:event3) { create(:event_with_associations) }

    it 'gets the events for the event list' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
        {
          'id' => event2.id,
          'name' => event2.name,
          'description' => event2.description,
          'due_at' => format_time(event2.due_at),
          'updated_at' => format_time(event2.updated_at),
          'created_at' => format_time(event2.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/#{event2.event_list.id}/events/#{event2.id}"
          }]
        },
        {
          'id' => event1.id,
          'name' => event1.name,
          'description' => event1.description,
          'due_at' => format_time(event1.due_at),
          'updated_at' => format_time(event1.updated_at),
          'created_at' => format_time(event1.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/#{event1.event_list.id}/events/#{event1.id}"
          }]
        }
      ])
    end
  end

  context '/event_lists/:event_list_id' do
    describe 'with an invalid parent resource' do
      let(:verb) { :get }
      let(:path) { '/api/v1/event_lists/1/events' }
      let(:params) {{}}

      let!(:event_list) { create(:event_list, :with_account, id: 1) }

      context 'with an event for another account' do
        it 'does not get the event' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(404)
        end

        it 'displays an error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'status' => 404,
            'status_code' => 'not_found',
            'error' => "Couldn't find EventList with id=1"
          )
        end
      end
    end

    describe 'GET index' do
      let(:verb) { :get }
      let(:path) { '/api/v1/event_lists/1/events' }
      let(:params) {{}}

      let!(:event_list) { create(:event_list, account: account, id: 1) }
      let!(:event1) { create(:event, event_list: event_list, account: account) }
      let!(:event2) { create(:event, event_list: event_list, account: account) }

      it 'gets the events for the current account' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq([
          {
            'id' => event2.id,
            'name' => event2.name,
            'description' => event2.description,
            'due_at' => format_time(event2.due_at),
            'updated_at' => format_time(event2.updated_at),
            'created_at' => format_time(event2.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/event_lists/1/events/#{event2.id}"
            }]
          },
          {
            'id' => event1.id,
            'name' => event1.name,
            'description' => event1.description,
            'due_at' => format_time(event1.due_at),
            'updated_at' => format_time(event1.updated_at),
            'created_at' => format_time(event1.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/event_lists/1/events/#{event1.id}"
            }]
          }
        ])
      end
    end

    describe 'GET show' do
      let(:verb) { :get }
      let(:path) { '/api/v1/event_lists/1/events/1' }
      let(:params) {{}}

      it_behaves_like 'requires authentication'

      #it_behaves_like 'handles invalid IDs'
      context 'with an event for another account' do
        let!(:event_list) { create(:event_list, account: account, id: 1) }

        it 'does not get the event' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(404)
        end

        it 'displays an error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'status' => 404,
            'status_code' => 'not_found',
            'error' => "Couldn't find Event with id=1"
          )
        end
      end

      context 'with an event for the event list' do
        let!(:event_list) { create(:event_list, account: account, id: 1) }
        let!(:event) { create(:event, event_list: event_list, account: account, id: 1) }

        it_behaves_like 'successful response'

        it 'gets the event' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => 1,
            'name' => event.name,
            'description' => event.description,
            'due_at' => format_time(event.due_at),
            'updated_at' => format_time(event.updated_at),
            'created_at' => format_time(event.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => 'https://test.host/api/v1/event_lists/1/events/1'
            }]
          )
        end
      end
    end

    describe 'POST create' do
      let(:verb) { :post }
      let(:path) { '/api/v1/event_lists/1/events' }
      let(:params) {{
        name: 'a name',
        description: 'a description',
        due_at: 10.days.from_now
      }}

      let!(:event_list) { create(:event_list, account: account, id: 1) }

      it_behaves_like 'requires authentication'

      context 'with valid parameters' do
        it 'has a created response' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(201)
        end

        it 'creates an event' do
          do_action(verb, path, access_token, params)
          event = ::Event.last
          expect(JSON.parse(response.body)).to eq(
            'id' => event.id,
            'name' => event.name,
            'description' => event.description,
            'due_at' => format_time(event.due_at),
            'updated_at' => format_time(event.updated_at),
            'created_at' => format_time(event.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/event_lists/1/events/#{event.id}"
            }]
          )
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ name: '', description: '', due_at: '' }}

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(422)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'error' => "Validation failed: name can't be blank, " +
                        "description can't be blank, " +
                        "due at can't be blank",
            'status' => 422,
            'status_code' => 'record_invalid'
          )
        end
      end

      context 'with missing parameters' do
        let(:params) {{}}

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(422)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'error' => 'Missing parameter: name',
            'status' => 422,
            'status_code' => 'record_invalid'
          )
        end
      end
    end

    describe 'PUT update' do
      let(:verb) { :put }
      let(:path) { '/api/v1/event_lists/1/events/1' }
      let(:params) {{
        name: 'a new name',
        description: 'a new description',
        due_at: '2000-01-21'
      }}

      let(:event_list) { create(:event_list, account: account, id: 1) }
      let!(:event) { create(:event, event_list: event_list, account: account, id: 1) }

      it_behaves_like 'requires authentication'

      context 'with valid parameters' do
        it_behaves_like 'successful response'

        it 'updates the event' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => event.id,
            'name' => 'a new name',
            'description' => 'a new description',
            'due_at' => '2000-01-21T00:00:00Z',
            'updated_at' => format_time(event.updated_at),
            'created_at' => format_time(event.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => 'https://test.host/api/v1/event_lists/1/events/1'
            }]
          )
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ name: '', description: '', due_at: '' }}

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(422)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'error' => "Validation failed: name can't be blank, " +
                        "description can't be blank, " +
                        "due at can't be blank",
            'status' => 422,
            'status_code' => 'record_invalid'
          )
        end
      end

      context 'with missing parameters' do
        let(:params) {{}}

        it 'is a successful request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(200)
        end

        it 'shows the unchanged event' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => event.id,
            'name' => event.name,
            'description' => event.description,
            'due_at' => format_time(event.due_at),
            'updated_at' => format_time(event.updated_at),
            'created_at' => format_time(event.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => 'https://test.host/api/v1/event_lists/1/events/1'
            }]
          )
        end
      end
    end

    describe 'DELETE destroy' do
      let(:verb) { :delete }
      let(:path) { '/api/v1/event_lists/1/events/1' }
      let(:params) {{}}

      let!(:event_list) { create(:event_list, account: account, id: 1) }
      let!(:event) { create(:event, event_list: event_list, account: account, id: 1) }

      it_behaves_like 'requires authentication'

      context 'with a valid ID' do
        it 'has a no content response' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(204)
        end

        it 'has no content' do
          do_action(verb, path, access_token, params)
          expect(response.body).to be_empty
        end

        it 'deletes the event' do
          do_action(verb, path, access_token, params)

          get '/api/v1/event_lists/1/events/1', {}, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{access_token}:")}"
          expect(response.status).to eq(404)
        end
      end

      context 'with an invalid ID' do
        let(:path) { '/api/v1/event_lists/1/events/-1' }

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(404)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'status' => 404,
            'status_code' => 'not_found',
            'error' => "Couldn't find Event with id=-1"
          )
        end
      end
    end
  end
end
