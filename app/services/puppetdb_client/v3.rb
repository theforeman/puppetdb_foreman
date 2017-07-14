module PuppetdbClient
  class V3 < Base
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

    def facts_url
      '/pdb/query/v4/facts'
    end

    def query_nodes
      super.map { |node| node['certname'] }
    end

    private

    def post_options
      {
        content_type: :json
      }
    end

    def producer_timestamp
      Time.now.iso8601.to_s
    end
  end
end
