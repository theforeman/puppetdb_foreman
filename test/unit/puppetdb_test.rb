require 'test_plugin_helper'

class PuppetdbTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryGirl.build(:user, :admin)
    setup_settings
    disable_orchestration
  end

  let(:client) { Puppetdb.client }

  context 'with V1 API' do
    setup do
      Setting[:puppetdb_address] = 'https://localhost:8080/v3/commands'
    end

    test 'deactivate_node' do
      stub_request(:post, 'https://localhost:8080/v3/commands')
        .with(:body => 'payload={"command":"deactivate node","version":1,"payload":"\\"www.example.com\\""}',
              :headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => "{\"uuid\" : \"#{SecureRandom.uuid}\"}", :headers => { 'Content-Type' => 'application/json; charset=utf-8' })

      assert_equal true, client.deactivate_node('www.example.com')
    end

    test 'query_nodes' do
      stub_request(:get, 'https://localhost:8080/v3/nodes')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('query_nodes.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      expected = (1..10).map { |i| "server#{i}.example.com" }
      assert_equal expected, client.query_nodes
    end
  end

  context 'with V3 API' do
    let(:producer_timestamp) { Time.now.iso8601.to_s }

    test 'deactivate_node' do
      client.stubs(:producer_timestamp).returns(producer_timestamp)

      stub_request(:post, 'https://puppetdb:8081/pdb/cmd/v1')
        .with(:body => "{\"command\":\"deactivate node\",\"version\":3,\"payload\":{\"certname\":\"www.example.com\",\"producer_timestamp\":\"#{producer_timestamp}\"}}",
              :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
        .to_return(:status => 200, :body => "{\"uuid\" : \"#{SecureRandom.uuid}\"}", :headers => { 'Content-Type' => 'application/json; charset=utf-8' })

      assert_equal true, client.deactivate_node('www.example.com')
    end

    test 'query_nodes' do
      stub_request(:get, 'https://puppetdb:8081/pdb/query/v4/nodes')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('query_nodes.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      expected = (1..10).map { |i| "server#{i}.example.com" }
      assert_equal expected, client.query_nodes
    end
  end
end
