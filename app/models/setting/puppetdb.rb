class Setting::Puppetdb < ::Setting
  BLANK_ATTRS << 'puppetdb_address'

  def self.load_defaults
    if SETTINGS[:puppetdb].present?
      default_enabled = SETTINGS[:puppetdb][:enabled]
      default_address = SETTINGS[:puppetdb][:address]
    end

    default_enabled = false if default_enabled.nil?
    default_address ||= 'https://puppetdb:8081/v2/commands'

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
  end
end
