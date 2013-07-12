shared_examples_for 'successful response' do
  it 'is a successful request' do
    do_action(verb, path, access_token, params)
    expect(response.status).to eq(200)
  end
end
