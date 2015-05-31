shared_examples_for "PrivatePub publishable" do
  it 'publish' do
    expect(PrivatePub).to receive(:publish_to).with(channel, anything)
    do_request
  end
end

shared_examples_for "PrivatePub not publishable" do
  it 'not publish' do
    expect(PrivatePub).to_not receive(:publish_to).with(channel, anything)
    do_request
  end
end