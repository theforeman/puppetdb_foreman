module Puppetdb
  API_VERSIONS = {
    '4' => 'v4: PuppetDB 4.0, 4.1, 4.2, 4.3',
    '3' => 'v3: PuppetDB 3.0, 3.1, 3.2',
    '1' => 'v1: PuppetDB 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 2.0, 2.1, 2.2, 2.3'
  }.freeze

  def self.client
    options = {
      :uri => uri,
      :ssl_ca_file => Setting[:puppetdb_ssl_ca_file],
      :ssl_certificate_file => Setting[:puppetdb_ssl_certificate],
      :ssl_private_key_file => Setting[:puppetdb_ssl_private_key]
    }

    case api_version
    when 1
      PuppetdbClient::V1.new(options)
    when 3
      PuppetdbClient::V3.new(options)
    when 4
      PuppetdbClient::V4.new(options)
    else
      raise Foreman::Exception, N_('Unsupported PuppetDB version.')
    end
  end

  def self.api_version
    Setting[:puppetdb_api_version].to_i
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
