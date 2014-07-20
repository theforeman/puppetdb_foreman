class Setting::Puppetdb < ::Setting
  BLANK_ATTRS << 'puppetdb_address'

  def self.load_defaults
    Setting.transaction do
      [
        self.set('puppetdb_enabled', _("Integration with PuppetDB, enabled will deactivate a host in PuppetDB when it's deleted in Foreman"), 'false'),
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end

    Setting.transaction do
      [
        self.set('puppetdb_address', _('Foreman will send PuppetDB requests to this address'), ''),
      ].compact.each { |s| self.create s.update(:category => 'Setting::Puppetdb')}
    end
  end
end
