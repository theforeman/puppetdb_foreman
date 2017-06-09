class Setting::Puppetdb < ::Setting
  BLANK_ATTRS << 'puppetdb_address'
  BLANK_ATTRS << 'puppetdb_ssl_ca_file'
  BLANK_ATTRS << 'puppetdb_ssl_certificate'
  BLANK_ATTRS << 'puppetdb_ssl_private_key'
  BLANK_ATTRS << 'puppetdb_api_version'

  def self.default_settings
    if SETTINGS[:puppetdb].present?
      default_enabled = SETTINGS[:puppetdb][:enabled]
      default_address = SETTINGS[:puppetdb][:address]
      default_dashboard_address = SETTINGS[:puppetdb][:dashboard_address]
      default_ssl_ca_file = SETTINGS[:puppetdb][:ssl_ca_file]
      default_ssl_certificate = SETTINGS[:puppetdb][:ssl_certificate]
      default_ssl_private_key = SETTINGS[:puppetdb][:ssl_private_key]
      default_api_version = SETTINGS[:puppetdb][:api_version]
    end

    default_enabled = false if default_enabled.nil?
    default_address ||= 'https://puppetdb:8081/pdb/cmd/v1'
    default_dashboard_address ||= 'http://puppetdb:8080/pdb/dashboard'
    default_ssl_ca_file ||= (SETTINGS[:ssl_ca_file]).to_s
    default_ssl_certificate ||= (SETTINGS[:ssl_certificate]).to_s
    default_ssl_private_key ||= (SETTINGS[:ssl_priv_key]).to_s
    default_api_version ||= 4

    [
      set('puppetdb_enabled', _("Integration with PuppetDB, enabled will deactivate a host in PuppetDB when it's deleted in Foreman"), default_enabled),
      set('puppetdb_address', _('Foreman will send PuppetDB requests to this address'), default_address),
      set('puppetdb_dashboard_address', _('Foreman will proxy PuppetDB Performance Dashboard requests to this address'), default_dashboard_address),
      set('puppetdb_ssl_ca_file', _('Foreman will send PuppetDB requests with this CA file'), default_ssl_ca_file),
      set('puppetdb_ssl_certificate', _('Foreman will send PuppetDB requests with this certificate file'), default_ssl_certificate),
      set('puppetdb_ssl_private_key', _('Foreman will send PuppetDB requests with this key file'), default_ssl_private_key),
      set('puppetdb_api_version', _('Foreman will use this PuppetDB API version'), default_api_version)
    ]
  end

  def self.load_defaults
    # Check the table exists
    return unless super

    transaction do
      default_settings.each { |s| create! s.update(:category => 'Setting::Puppetdb') }
    end

    true
  end

  def self.humanized_category
    N_('PuppetDB')
  end
end
