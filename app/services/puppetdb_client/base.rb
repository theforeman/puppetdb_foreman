module PuppetdbClient
  class Base
    delegate :logger, :to => :Rails
    attr_reader :uri, :ssl_ca_file, :ssl_certificate_file, :ssl_private_key_file

    def initialize(opts)
      @uri = opts.fetch(:uri)
      @ssl_ca_file = opts.fetch(:ssl_ca_file)
      @ssl_certificate_file = opts.fetch(:ssl_certificate_file)
      @ssl_private_key_file = opts.fetch(:ssl_private_key_file)
    end

    def deactivate_node(nodename)
      body = parse(post(command_url, deactivate_node_payload(nodename)))
      uuid = body['uuid']
      logger.info "Submitted deactivate_node job to PuppetDB with UUID: #{uuid}"
      uuid
    end

    def query_nodes
      parse(get(nodes_url))
    end

    def facts(nodename)
      parse(get(facts_url, query: "[\"=\", \"certname\", \"#{nodename}\"]"))
    end

    private

    def connection(url)
      RestClient::Resource.new(
        request_url(url),
        request_options
      )
    end

    def request_url(url)
      URI.join(baseurl, url).to_s
    end

    def baseurl
      "#{uri.scheme}://#{uri.host}:#{uri.port}"
    end

    def get(endpoint, params = {})
      logger.debug "PuppetdbClient: GET request to #{endpoint} with params: #{params}"
      connection(endpoint).get(params: params).body
    end

    def post(endpoint, payload)
      logger.debug "PuppetdbClient: POST request to #{endpoint} with payload: #{payload}"
      connection(endpoint).post(payload, post_options).body
    end

    def parse(body)
      JSON.parse(body)
    end

    def post_options
      {}
    end

    def request_options
      {
        headers: request_headers
      }.merge(auth_options).merge(ssl_options)
    end

    def request_headers
      {
        'Accept' => 'application/json'
      }
    end

    def ssl_options
      if ssl_ca_file
        {
          ssl_ca_file: ssl_ca_file,
          verify_ssl: true
        }
      else
        {
          verify_ssl: false
        }
      end
    end

    def auth_options
      return {} unless certificate_request?
      {
        ssl_client_cert: ssl_certificate,
        ssl_client_key: ssl_private_key
      }
    end

    def certificate_request?
      ssl_certificate_file.present? && ssl_private_key_file.present?
    end

    def ssl_certificate
      OpenSSL::X509::Certificate.new(File.read(ssl_certificate_file))
    end

    def ssl_private_key
      OpenSSL::PKey::RSA.new(File.read(ssl_private_key_file), nil)
    end
  end
end
