require 'test_plugin_helper'

class PuppetdbTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryGirl.build(:user, :admin)
    setup_settings
    disable_orchestration
  end

  let(:client) { Puppetdb.client }
  let(:uuid) { SecureRandom.uuid }

  context 'with V1 API' do
    setup do
      Setting[:puppetdb_api_version] = 1
      Setting[:puppetdb_address] = 'https://localhost:8080/v3/commands'
    end

    test 'deactivate_node' do
      stub_request(:post, 'https://localhost:8080/v3/commands')
        .with(:body => 'payload={"command":"deactivate node","version":1,"payload":"\\"www.example.com\\""}',
              :headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => "{\"uuid\" : \"#{uuid}\"}", :headers => { 'Content-Type' => 'application/json; charset=utf-8' })

      assert_equal uuid, client.deactivate_node('www.example.com')
    end

    test 'query_nodes' do
      stub_request(:get, 'https://localhost:8080/v3/nodes')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('query_nodes.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      expected = (1..10).map { |i| "server#{i}.example.com" }
      assert_equal expected, client.query_nodes
    end

    test 'facts' do
      stub_request(:get, 'https://localhost:8080/v3/facts?query=%5B%22=%22,%20%22certname%22,%20%22host.example.com%22%5D')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('facts.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      facts = client.facts('host.example.com')
      assert_kind_of Array, facts
      sample = {
        'value' => 'CEST',
        'name' => 'timezone',
        'certname' => 'host.example.com'
      }
      assert_includes facts, sample
    end
  end

  context 'with V3 API' do
    setup do
      Setting[:puppetdb_api_version] = 3
    end

    let(:producer_timestamp) { Time.now.iso8601.to_s }

    test 'deactivate_node' do
      client.stubs(:producer_timestamp).returns(producer_timestamp)

      stub_request(:post, 'https://puppetdb:8081/pdb/cmd/v1')
        .with(:body => "{\"command\":\"deactivate node\",\"version\":3,\"payload\":{\"certname\":\"www.example.com\",\"producer_timestamp\":\"#{producer_timestamp}\"}}",
              :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
        .to_return(:status => 200, :body => "{\"uuid\" : \"#{uuid}\"}", :headers => { 'Content-Type' => 'application/json; charset=utf-8' })

      assert_equal uuid, client.deactivate_node('www.example.com')
    end

    test 'query_nodes' do
      stub_request(:get, 'https://puppetdb:8081/pdb/query/v4/nodes')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('query_nodes_v3_4.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      expected = (1..10).map { |i| "server#{i}.example.com" }
      assert_equal expected, client.query_nodes
    end

    test 'facts' do
      stub_request(:get, 'https://puppetdb:8081/pdb/query/v4/facts?query=%5B%22=%22,%20%22certname%22,%20%22host.example.com%22%5D')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('facts.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      facts = client.facts('host.example.com')
      assert_kind_of Array, facts
      sample = {
        'value' => 'CEST',
        'name' => 'timezone',
        'certname' => 'host.example.com'
      }
      assert_includes facts, sample
    end
  end

  context 'with V4 API' do
    setup do
      Setting[:puppetdb_api_version] = 4
    end

    let(:producer_timestamp) { Time.now.iso8601.to_s }

    test 'deactivate_node' do
      client.stubs(:producer_timestamp).returns(producer_timestamp)

      stub_request(:post, 'https://puppetdb:8081/pdb/cmd/v1')
        .with(:body => "{\"command\":\"deactivate node\",\"version\":3,\"payload\":{\"certname\":\"www.example.com\",\"producer_timestamp\":\"#{producer_timestamp}\"}}",
              :headers => { 'Accept' => 'application/json', 'Content-Type' => 'application/json' })
        .to_return(:status => 200, :body => "{\"uuid\" : \"#{uuid}\"}", :headers => { 'Content-Type' => 'application/json; charset=utf-8' })

      assert_equal uuid, client.deactivate_node('www.example.com')
    end

    test 'query_nodes' do
      stub_request(:get, 'https://puppetdb:8081/pdb/query/v4/nodes')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('query_nodes_v3_4.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      expected = (1..10).map { |i| "server#{i}.example.com" }
      assert_equal expected, client.query_nodes
    end

    test 'facts' do
      stub_request(:get, 'https://puppetdb:8081/pdb/query/v4/facts?query=%5B%22=%22,%20%22certname%22,%20%22host.example.com%22%5D')
        .with(:headers => { 'Accept' => 'application/json' })
        .to_return(:status => 200, :body => fixture('facts.json'), :headers => { 'Content-Type' => 'application/json; charset=utf-8' })
      facts = client.facts('host.example.com')
      assert_kind_of Array, facts
      sample = {
        'value' => 'CEST',
        'name' => 'timezone',
        'certname' => 'host.example.com'
      }
      assert_includes facts, sample
    end
  end

  context 'when the puppetdb version is not supported' do
    setup do
      Setting[:puppetdb_api_version] = -10
    end

    test 'it raises error about unsupported version' do
      assert_raises Puppetdb::UnsupportedVersion do
        client
      end
    end
  end
end
