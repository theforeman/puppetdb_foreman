# frozen_string_literal: true

module Puppetdb
  API_VERSIONS = {
    '4' => 'v4: PuppetDB 4 - 7',
  }.freeze

  def self.client # rubocop:disable Metrics/MethodLength
    options = {
      uri: uri,
      ssl_ca_file: Setting[:puppetdb_ssl_ca_file],
      ssl_certificate_file: Setting[:puppetdb_ssl_certificate],
      ssl_private_key_file: Setting[:puppetdb_ssl_private_key],
    }

    case api_version
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
