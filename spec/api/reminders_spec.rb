require 'spec_helper'

describe API::Reminders, :api do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  before do
    Timecop.freeze(2000, 1, 1)
  end

  after do
    Timecop.return
  end

  context '/events/:event_id' do
    describe 'with an invalid parent resource' do
      let(:verb) { :get }
      let(:path) { '/api/v1/events/1/reminders' }
      let(:params) {{}}

      let!(:event) { create(:event_with_associations, id: 1) }

      context 'with an event for another account' do
        it 'does not get the event ' do
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
    end

    describe 'GET index' do
      let(:verb) { :get }
      let(:path) { '/api/v1/events/1/reminders' }
      let(:params) {{}}

      let(:event) { create(:event, :with_event_list, account: account, id: 1) }
      let!(:reminder1) { create(:reminder, event: event) }
      let!(:reminder2) { create(:reminder, event: event) }

      it 'gets the events for the current account' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq([
          {
            'id' => reminder1.id,
            'reminded_at' => format_time(reminder1.reminded_at),
            'updated_at' => format_time(reminder1.updated_at),
            'created_at' => format_time(reminder1.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/events/1/reminders/#{reminder1.id}"
            }]
          },
          {
            'id' => reminder2.id,
            'reminded_at' => format_time(reminder2.reminded_at),
            'updated_at' => format_time(reminder2.updated_at),
            'created_at' => format_time(reminder2.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/events/1/reminders/#{reminder2.id}"
            }]
          }
        ])
      end
    end

    describe 'GET show' do
      let(:verb) { :get }
      let(:path) { '/api/v1/events/1/reminders/1' }
      let(:params) {{}}

      it_behaves_like 'requires authentication'

      #it_behaves_like 'handles invalid IDs'
      context 'with a reminder for another account' do
        let!(:event) { create(:event, :with_event_list, account: account, id: 1) }

        it 'does not get the reminder' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(404)
        end

        it 'displays an error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'status' => 404,
            'status_code' => 'not_found',
            'error' => "Couldn't find Reminder with id=1"
          )
        end
      end

      context 'with a reminder for the current account' do
        let(:event) { create(:event, :with_event_list, account: account, id: 1) }
        let!(:reminder) { create(:reminder, event: event, id: 1) }

        it_behaves_like 'successful response'

        it 'gets the reminder' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => reminder.id,
            'reminded_at' => format_time(reminder.reminded_at),
            'updated_at' => format_time(reminder.updated_at),
            'created_at' => format_time(reminder.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/events/1/reminders/#{reminder.id}"
            }]
          )
        end
      end
    end

    describe 'POST create' do
      let(:verb) { :post }
      let(:path) { '/api/v1/events/1/reminders' }
      let(:params) {{ reminded_at: 10.days.from_now }}

      let!(:event) { create(:event, :with_event_list, account: account, id: 1) }

      it_behaves_like 'requires authentication'

      context 'with valid parameters' do
        it 'has a created response' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(201)
        end

        it 'creates a reminder' do
          do_action(verb, path, access_token, params)
          reminder = ::Reminder.last
          expect(JSON.parse(response.body)).to eq(
            'id' => reminder.id,
            'reminded_at' => format_time(reminder.reminded_at),
            'updated_at' => format_time(reminder.updated_at),
            'created_at' => format_time(reminder.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => "https://test.host/api/v1/events/1/reminders/#{reminder.id}"
            }]
          )
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ reminded_at: '' }}

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(422)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'error' => "Validation failed: reminded at can't be blank",
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
            'error' => 'Missing parameter: reminded_at',
            'status' => 422,
            'status_code' => 'record_invalid'
          )
        end
      end
    end

    describe 'PUT update' do
      let(:verb) { :put }
      let(:path) { '/api/v1/events/1/reminders/1' }
      let(:params) {{
        reminded_at: '2000-01-21'
      }}

      let(:event) { create(:event, :with_event_list, account: account, id: 1) }
      let!(:reminder) { create(:reminder, event: event, id: 1) }

      it_behaves_like 'requires authentication'

      context 'with valid parameters' do
        it_behaves_like 'successful response'

        it 'updates the reminder' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => reminder.id,
            'reminded_at' => '948412800',
            'updated_at' => format_time(reminder.updated_at),
            'created_at' => format_time(reminder.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => 'https://test.host/api/v1/events/1/reminders/1'
            }]
          )
        end
      end

      context 'with invalid parameters' do
        let(:params) {{ reminded_at: '' }}

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(422)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'error' => "Validation failed: reminded at can't be blank",
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

        it 'shows the unchanged reminder' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'id' => reminder.id,
            'reminded_at' => format_time(reminder.reminded_at),
            'updated_at' => format_time(reminder.updated_at),
            'created_at' => format_time(reminder.created_at),
            'links' => [{
              'rel' => 'self',
              'href' => 'https://test.host/api/v1/events/1/reminders/1'
            }]
          )
        end
      end
    end

    describe 'DELETE destroy' do
      let(:verb) { :delete }
      let(:path) { '/api/v1/events/1/reminders/1' }
      let(:params) {{}}

      let(:event) { create(:event, :with_event_list, account: account, id: 1) }
      let!(:reminder1) { create(:reminder, event: event, id: 1) }

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

        it 'deletes the reminder' do
          do_action(verb, path, access_token, params)

          get '/api/v1/events/1/reminders/1', {}, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{access_token}:")}"
          expect(response.status).to eq(404)
        end
      end

      context 'with an invalid ID' do
        let(:path) { '/api/v1/events/1/reminders/-1' }

        it 'is a bad request' do
          do_action(verb, path, access_token, params)
          expect(response.status).to eq(404)
        end

        it 'shows the error message' do
          do_action(verb, path, access_token, params)
          expect(JSON.parse(response.body)).to eq(
            'status' => 404,
            'status_code' => 'not_found',
            'error' => "Couldn't find Reminder with id=-1"
          )
        end
      end
    end
  end
end
