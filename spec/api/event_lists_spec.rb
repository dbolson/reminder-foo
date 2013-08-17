require 'spec_helper'

describe API::EventLists, :api do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  describe 'GET index' do
    let(:verb) { :get }
    let(:path) { '/api/v1/event_lists' }
    let(:params) {{}}

    let!(:event_list1) { create(:event_list, account: account) }
    let!(:event_list2) { create(:event_list, :with_account) }
    let!(:event_list3) { create(:event_list, account: account) }

    it_behaves_like 'requires authentication'
    it_behaves_like 'successful response'

    it 'gets the event lists for the current account' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
        {
          'id' => event_list3.id,
          'name' => event_list3.name,
          'updated_at' => format_time(event_list3.updated_at),
          'created_at' => format_time(event_list3.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/#{event_list3.id}"
          }]
        },
        {
          'id' => event_list1.id,
          'name' => event_list1.name,
          'updated_at' => format_time(event_list1.updated_at),
          'created_at' => format_time(event_list1.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/#{event_list1.id}"
          }]
        }
      ])
    end
  end

  describe 'GET show' do
    let(:verb) { :get }
    let(:path) { '/api/v1/event_lists/1' }
    let(:params) {{}}

    it_behaves_like 'requires authentication'

    #it_behaves_like 'handles invalid IDs'
    context 'with an event list for another account' do
      it 'does not get the event list' do
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

    context 'with an event list for the current account' do
      let!(:event_list) { create(:event_list, account: account, id: 1) }

      it_behaves_like 'successful response'

      it 'gets the event list' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'id' => 1,
          'name' => event_list.name,
          'updated_at' => format_time(event_list.updated_at),
          'created_at' => format_time(event_list.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => 'https://test.host/api/v1/event_lists/1'
          }]
        )
      end
    end
  end

  describe 'POST create' do
    let(:verb) { :post }
    let(:path) { '/api/v1/event_lists' }
    let(:params) {{ 'name' => 'a name' }}

    it_behaves_like 'requires authentication'

    context 'with valid parameters' do
      it 'has a created response' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(201)
      end

      it 'creates an event list' do
        do_action(verb, path, access_token, params)
        event_list = ::EventList.last
        expect(JSON.parse(response.body)).to eq(
          'id' => event_list.id,
          'name' => event_list.name,
          'updated_at' => format_time(event_list.updated_at),
          'created_at' => format_time(event_list.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/#{event_list.id}"
          }]
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) {{ name: '' }}

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(422)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'error' => "Validation failed: name can't be blank",
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
    let(:path) { '/api/v1/event_lists/1' }
    let(:params) {{ 'name' => 'a new name' }}

    let!(:event_list) { create(:event_list, account: account, id: 1) }

    it_behaves_like 'requires authentication'

    context 'with valid parameters' do
      it_behaves_like 'successful response'

      it 'updates an event list' do
        do_action(verb, path, access_token, params)
        event_list = ::EventList.last
        expect(JSON.parse(response.body)).to eq(
          'id' => event_list.id,
          'name' => 'a new name',
          'updated_at' => format_time(event_list.updated_at),
          'created_at' => format_time(event_list.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/1"
          }]
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) {{ name: '' }}

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(422)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'error' => "Validation failed: name can't be blank",
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

      it 'shows the unchanged event list' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'id' => event_list.id,
          'name' => event_list.name,
          'updated_at' => format_time(event_list.updated_at),
          'created_at' => format_time(event_list.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/event_lists/1"
          }]
        )
      end
    end
  end

  describe 'DELETE destroy' do
    let(:verb) { :delete }
    let(:path) { '/api/v1/event_lists/1' }
    let(:params) {{}}

    let!(:event_list) { create(:event_list, account: account, id: 1) }

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

      it 'deletes the event list' do
        do_action(verb, path, access_token, params)

        get '/api/v1/event_lists/1', {}, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{access_token}:")}"
        expect(response.status).to eq(404)
      end
    end

    context 'with an invalid ID' do
      let(:path) { '/api/v1/event_lists/-1' }

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find EventList with id=-1"
        )
      end
    end
  end

  describe 'GET subscribers' do
    let(:verb) { :get }
    let(:path) { '/api/v1/event_lists/1/subscribers' }
    let(:params) {{}}

    let!(:event_list) { create(:event_list, account: account, id: 1) }
    let!(:subscriber1) { create(:subscriber, account: account) }
    let!(:subscriber2) { create(:subscriber, :with_account) }
    let!(:subscription) {
      create(:subscription, account: account, event_list: event_list, subscriber: subscriber1)
    }

    it_behaves_like 'requires authentication'
    it_behaves_like 'successful response'

    it 'gets the subscribers for the event list' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
        {
          'id' => subscriber1.id,
          'phone_number' => subscriber1.phone_number,
          'updated_at' => format_time(subscriber1.updated_at),
          'created_at' => format_time(subscriber1.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscribers/#{subscriber1.id}"
          }]
        }
      ])
    end

    context 'with an invalid ID' do
      let(:path) { '/api/v1/event_lists/-1/subscribers' }

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find EventList with id=-1"
        )
      end
    end
  end
end
