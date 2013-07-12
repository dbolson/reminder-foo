shared_examples_for 'requires authentication' do
  context 'with an invalid api key' do
    it 'is unauthorized' do
      do_action(verb, path, 'bad-key', params)
      expect(response.status).to eq(401)
    end

    it 'has an error response' do
      do_action(verb, path, 'bad-key', params)
      expect(response.body).to eq('')
    end
  end
end
