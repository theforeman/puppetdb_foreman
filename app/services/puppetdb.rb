module Puppetdb
  def self.client
    options = {
      :uri => uri,
      :ssl_ca_file => Setting[:puppetdb_ssl_ca_file],
      :ssl_certificate_file => Setting[:puppetdb_ssl_certificate],
      :ssl_private_key_file => Setting[:puppetdb_ssl_private_key]
    }
    if uri.path.start_with?('/pdb')
      PuppetdbClient::V3.new(options)
    else
      PuppetdbClient::V1.new(options)
    end
  end

  def self.uri
    URI.parse(Setting[:puppetdb_address])
  end

  def self.enabled?
    [true, 'true'].include? Setting[:puppetdb_enabled]
  end

  def self.configured?
    Setting[:puppetdb_address].present?
  end

  def self.ready?
    enabled? && configured?
  end
end
