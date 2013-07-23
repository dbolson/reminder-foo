require File.expand_path('spec_fast/fast_spec_helper')
require File.expand_path('app/services/account_creating')

describe Services::AccountCreating do
  describe '#create' do
    let(:account_type) { stub(:account_type, new: new_account) }
    let(:new_account) { stub(:new_account).as_null_object }
    let(:creating) { Services::AccountCreating }

    def create
      creating.stub(:account_type) { account_type }
      creating.create(params: 'params')
    end

    context 'with valid params' do
      before do
        new_account.stub(:save) { true }
      end

      it 'saves the account' do
        new_account.should_receive(:save) { true }
        create
      end

      it 'creates an api key for the account' do
        new_account.should_receive(:create_api_key)
        create
      end

      it 'returns the account' do
        created = create
        expect(created).to eq new_account
      end
    end

    context 'with invalid params' do
      before do
        new_account.stub(:save) { false }
      end

      it 'does not save the account' do
        new_account.should_not_receive(:create_api_key)
        create
      end

      it 'returns the account' do
        created = create
        expect(created).to eq new_account
      end
    end
  end
end
