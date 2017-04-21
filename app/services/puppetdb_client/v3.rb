module PuppetdbClient
  class V3 < Base
    def post_request(endpoint, payload)
      req = super
      req.content_type = 'application/json'
      req
    end

    # The payload is formatted as a JSON map.
    # certname: The name of the node for which the catalog was compiled.
    # producer_timestamp: The time of command submission.
    def deactivate_node_payload(nodename)
      {
        'command' => 'deactivate node',
        'version' => 3,
        'payload' => {
          'certname' => nodename,
          'producer_timestamp' => producer_timestamp
        }
      }.to_json
    end

    def command_url
      '/pdb/cmd/v1'
    end

    def nodes_url
      '/pdb/query/v4/nodes'
    end

    private

    def producer_timestamp
      Time.now.iso8601.to_s
    end
  end
end
