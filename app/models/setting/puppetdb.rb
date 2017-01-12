class Setting::Puppetdb < ::Setting
  BLANK_ATTRS << 'puppetdb_address'

  def self.load_defaults
    if SETTINGS[:puppetdb].present?
      default_enabled = SETTINGS[:puppetdb][:enabled]
      default_address = SETTINGS[:puppetdb][:address]
      default_dashboard_address = SETTINGS[:puppetdb][:dashboard_address]
      default_ssl_ca_file= SETTINGS[:puppetdb][:ssl_ca_file]
      default_ssl_certificate = SETTINGS[:puppetdb][:ssl_certificate]
      default_ssl_private_key = SETTINGS[:puppetdb][:ssl_private_key]
    end

    default_enabled = false if default_enabled.nil?
    default_address ||= 'https://puppetdb:8081/pdb/cmd/v1'
    default_dashboard_address ||= 'http://puppetdb:8080/pdb/dashboard'
    default_ssl_ca_file ||= "#{SETTINGS[:ssl_ca_file]}"
    default_ssl_certificate ||= "#{SETTINGS[:ssl_certificate]}"
    default_ssl_private_key ||= "#{SETTINGS[:ssl_priv_key]}"

    Setting.transaction do
      [
        self.set('puppetdb_enabled', _("Integration with PuppetDB, enabled will deactivate a host in PuppetDB when it's deleted in Foreman"), default_enabled)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_address', _('Foreman will send PuppetDB requests to this address'), default_address)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_dashboard_address', _('Foreman will proxy PuppetDB Performance Dashboard requests to this address'), default_dashboard_address)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_ssl_ca_file', _('Foreman will send PuppetDB requests with this CA file'), default_ssl_ca_file)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_ssl_certificate', _('Foreman will send PuppetDB requests with this certificate file'), default_ssl_certificate)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_ssl_private_key', _('Foreman will send PuppetDB requests with this key file'), default_ssl_private_key)
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end
  end
end
