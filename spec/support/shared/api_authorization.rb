shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it "return 401 status if there is no access token " do
      do_request
      expect(response.status).to eq 401
    end

    it "return 401 status if access token is invalid" do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for "API successful" do
  it 'returns 200 status code' do
    expect(response).to be_success
  end
end
