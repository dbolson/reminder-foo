require 'spec_helper'

describe API::Subscriptions, :api do
  let(:api_key) { create(:api_key) }
  let(:account) { api_key.account }
  let(:access_token) { api_key.access_token }

  describe 'GET index' do
    let(:verb) { :get }
    let(:path) { '/api/v1/subscriptions' }
    let(:params) {{}}

    let!(:subscription1) { create(:subscription, account: account) }
    let!(:subscription2) { create(:subscription, :with_account) }
    let!(:subscription3) { create(:subscription, account: account) }

    it_behaves_like 'requires authentication'
    it_behaves_like 'successful response'

    it 'gets the subscriptions for the current account' do
      do_action(verb, path, access_token, params)
      expect(JSON.parse(response.body)).to eq([
        {
          'id' => subscription1.id,
          'updated_at' => format_time(subscription1.updated_at),
          'created_at' => format_time(subscription1.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscriptions/#{subscription1.id}"
          }]
        },
        {
          'id' => subscription3.id,
          'updated_at' => format_time(subscription3.updated_at),
          'created_at' => format_time(subscription3.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscriptions/#{subscription3.id}"
          }]
        }
      ])
    end
  end

  describe 'GET show' do
    let(:verb) { :get }
    let(:path) { '/api/v1/subscriptions/1' }
    let(:params) {{}}

    it_behaves_like 'requires authentication'

    context 'with a subscription for another account' do
      it 'does not get the subscription' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'displays an error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find Subscription with id=1"
        )
      end
    end

    context 'with a subscription for the current account' do
      let!(:subscription) { create(:subscription, account: account, id: 1) }

      it_behaves_like 'successful response'

      it 'gets the subscription' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'id' => 1,
          'updated_at' => format_time(subscription.updated_at),
          'created_at' => format_time(subscription.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => 'https://test.host/api/v1/subscriptions/1'
          }]
        )
      end
    end
  end

  describe 'POST create' do
    let(:verb) { :post }
    let(:path) { '/api/v1/subscriptions' }
    let(:params) {
      {
        'event_list_id' => event_list.id,
        'subscriber_id' => subscriber.id
      }
    }

    let(:event_list) { create(:event_list, account: account) }
    let(:subscriber) { create(:subscriber, account: account) }

    it_behaves_like 'requires authentication'

    context 'with valid parameters' do
      it 'has a created response' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(201)
      end

      it 'creates a subscription' do
        do_action(verb, path, access_token, params)
        subscription = ::Subscription.last
        expect(JSON.parse(response.body)).to eq(
          'id' => subscription.id,
          'updated_at' => format_time(subscription.updated_at),
          'created_at' => format_time(subscription.created_at),
          'links' => [{
            'rel' => 'self',
            'href' => "https://test.host/api/v1/subscriptions/#{subscription.id}"
          }]
        )
      end
    end

    context 'with invalid parameters' do
      let(:params) {{ event_list_id: '', subscriber_id: '' }}

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(422)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'error' => "Validation failed: event list can't be blank, subscriber can't be blank",
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
          'error' => 'Missing parameter: event_list_id',
          'status' => 422,
          'status_code' => 'record_invalid'
        )
      end
    end
  end

  describe 'DELETE destroy' do
    let(:verb) { :delete }
    let(:path) { '/api/v1/subscriptions/1' }
    let(:params) {{}}

    let!(:subscription) { create(:subscription, account: account, id: 1) }

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

      it 'deletes the subscription' do
        do_action(verb, path, access_token, params)

        get '/api/v1/subscriptions/1', {}, 'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64("#{access_token}:")}"
        expect(response.status).to eq(404)
      end
    end

    context 'with an invalid ID' do
      let(:path) { '/api/v1/subscriptions/-1' }

      it 'is a bad request' do
        do_action(verb, path, access_token, params)
        expect(response.status).to eq(404)
      end

      it 'shows the error message' do
        do_action(verb, path, access_token, params)
        expect(JSON.parse(response.body)).to eq(
          'status' => 404,
          'status_code' => 'not_found',
          'error' => "Couldn't find Subscription with id=-1"
        )
      end
    end
  end
end
