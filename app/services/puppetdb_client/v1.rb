module PuppetdbClient
  class V1 < Base
    # The payload is expected to be the certname of a node as a serialized JSON string.
    def deactivate_node_payload(nodename)
      payload = {
        'command' => 'deactivate node',
        'version' => 1,
        'payload' => nodename.to_json
      }.to_json
      'payload=' + payload
    end

    def command_url
      '/v3/commands'
    end

    def nodes_url
      '/v3/nodes'
    end
  end
end
