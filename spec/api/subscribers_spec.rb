require 'spec_helper'

describe API::Subscribers, :api do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  describe 'GET index' do
    let(:verb) { :get }
    let(:path) { '/api/v1/subscribers' }
    let(:params) {{}}

    let!(:subscriber1) { create(:subscriber, account: account) }
    let!(:subscriber2) { create(:subscriber, :with_account) }
    let!(:subscriber3) { create(:subscriber, account: account) }

    it_behaves_like 'requires authentication'
    it_behaves_like 'successful response'

    it 'gets the subscribers for the current account' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
        {
          'id' => subscriber3.id,
          'phone_number' => subscriber3.phone_number,
          'updated_at' => format_time(subscriber3.updated_at),
          'created_at' => format_time(subscriber3.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscribers/#{subscriber3.id}"
          }]
        },
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
  end

  describe 'GET show' do
    let(:verb) { :get }
    let(:path) { '/api/v1/subscribers/1' }
    let(:params) {{}}

    it_behaves_like 'requires authentication'

    #it_behaves_like 'handles invalid IDs'
    context 'with a subscriber for another account' do
      it 'does not get the subscriber' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'displays an error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find Subscriber with id=1"
        )
      end
    end

    context 'with a subscriber for the current account' do
      let!(:subscriber) { create(:subscriber, account: account, id: 1) }

      it_behaves_like 'successful response'

      it 'gets the subscriber' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'id' => 1,
          'phone_number' => subscriber.phone_number,
          'updated_at' => format_time(subscriber.updated_at),
          'created_at' => format_time(subscriber.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => 'https://test.host/api/v1/subscribers/1'
          }]
        )
      end
    end
  end

  describe 'POST create' do
    let(:verb) { :post }
    let(:path) { '/api/v1/subscribers' }
    let(:params) {{ 'phone_number' => '15555555555' }}

    it_behaves_like 'requires authentication'

    context 'with valid parameters' do
      it 'has a created response' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(201)
      end

      it 'creates a subscriber' do
        do_action(verb, path, access_token, params)
        subscriber = ::Subscriber.last
        expect(JSON.parse(response.body)).to eq(
          'id' => subscriber.id,
          'phone_number' => subscriber.phone_number,
          'updated_at' => format_time(subscriber.updated_at),
          'created_at' => format_time(subscriber.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscribers/#{subscriber.id}"
          }]
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) {{ phone_number: '' }}

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(422)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'error' => "Validation failed: phone number can't be blank",
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
          'error' => 'Missing parameter: phone_number',
          'status' => 422,
          'status_code' => 'record_invalid'
        )
      end
    end
  end

  describe 'PUT update' do
    let(:verb) { :put }
    let(:path) { '/api/v1/subscribers/1' }
    let(:params) {{ 'phone_number' => '15555555556' }}

    let!(:subscriber) { create(:subscriber, account: account, id: 1) }

    it_behaves_like 'requires authentication'

    context 'with valid parameters' do
      it_behaves_like 'successful response'

      it 'updates the subscriber' do
        do_action(verb, path, access_token, params)
        subscriber = ::Subscriber.last
        expect(JSON.parse(response.body)).to eq(
          'id' => subscriber.id,
          'phone_number' => '15555555556',
          'updated_at' => format_time(subscriber.updated_at),
          'created_at' => format_time(subscriber.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscribers/1"
          }]
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) {{ phone_number: '' }}

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(422)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'error' => "Validation failed: phone number can't be blank",
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

      it 'shows the unchanged subscriber' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'id' => subscriber.id,
          'phone_number' => subscriber.phone_number,
          'updated_at' => format_time(subscriber.updated_at),
          'created_at' => format_time(subscriber.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => 'https://test.host/api/v1/subscribers/1'
          }]
        )
      end
    end
  end

  describe 'DELETE destroy' do
    let(:verb) { :delete }
    let(:path) { '/api/v1/subscribers/1' }
    let(:params) {{}}

    let!(:subscriber) { create(:subscriber, account: account, id: 1) }

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

      it 'deletes the subscriber' do
        do_action(verb, path, access_token, params)

        get '/api/v1/subscribers/1', {}, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{access_token}:")}"
        expect(response.status).to eq(404)
      end
    end

    context 'with an invalid ID' do
      let(:path) { '/api/v1/subscribers/-1' }

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find Subscriber with id=-1"
        )
      end
    end
  end

  describe 'GET event_lists' do
    let(:verb) { :get }
    let(:path) { '/api/v1/subscribers/1/event_lists' }
    let(:params) {{}}

    let!(:subscriber) { create(:subscriber, account: account, id: 1) }
    let!(:event_list1) { create(:event_list, account: account) }
    let!(:event_list2) { create(:event_list, account: account) }
    let!(:subscription) {
      create(:subscription, account: account, event_list: event_list1, subscriber: subscriber)
    }

    it_behaves_like 'requires authentication'
    it_behaves_like 'successful response'

    it 'gets the event lists for the subscriber' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
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

    context 'with an invalid ID' do
      let(:path) { '/api/v1/subscribers/-1/event_lists' }

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find Subscriber with id=-1"
        )
      end
    end
  end
end
