module Puppetdb

  class UnsupportedVersion < StandardError; end

  def self.client
    options = {
      :uri => uri,
      :ssl_ca_file => Setting[:puppetdb_ssl_ca_file],
      :ssl_certificate_file => Setting[:puppetdb_ssl_certificate],
      :ssl_private_key_file => Setting[:puppetdb_ssl_private_key]
    }

    api_version = Setting[:puppetdb_api_version].to_i

    case api_version
    when 1
      PuppetdbClient::V1.new(options)
    when 3
      PuppetdbClient::V3.new(options)
    when 4
      PuppetdbClient::V4.new(options)
    else
      raise ::Puppetdb::UnsupportedVersion
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
