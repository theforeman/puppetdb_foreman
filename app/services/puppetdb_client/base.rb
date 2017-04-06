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
      post(uri.path, deactivate_node_payload(nodename))
    end

    private

    def post_request(endpoint, payload)
      req = Net::HTTP::Post.new(endpoint)
      req['Accept'] = 'application/json'
      req.body = payload
      req
    end

    def post(endpoint, payload)
      req = post_request(endpoint, payload)
      connection.start do |http|
        response = http.request(req)
        response_ok?(response)
      end
    end

    def response_ok?(response)
      raise Foreman::Exception.new(N_('Failed to deactivate node on PuppetDB: %s'), response.body) unless response.code == '200'
      body = JSON.parse(response.body)
      logger.info "Submitted deactivate_node job to PuppetDB with UUID: #{body['uuid']}"
      true
    end

    def connection
      res             = Net::HTTP.new(uri.host, uri.port)
      res.use_ssl     = uri.scheme == 'https'
      if res.use_ssl?
        if ssl_ca_file
          res.ca_file = ssl_ca_file
          res.verify_mode = OpenSSL::SSL::VERIFY_PEER
        else
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        if ssl_certificate_file && ssl_private_key_file
          res.cert = ssl_certificate
          res.key  = ssl_private_key
        end
      end
      res
    end

    def ssl_certificate
      OpenSSL::X509::Certificate.new(File.read(ssl_certificate_file))
    end

    def ssl_private_key
      OpenSSL::PKey::RSA.new(File.read(ssl_private_key_file), nil)
    end
  end
end
