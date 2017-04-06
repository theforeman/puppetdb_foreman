module PuppetdbForeman
  module HostExtensions
    extend ActiveSupport::Concern
    included do
      include Orchestration::Puppetdb

      after_build :deactivate_host
    end

    def deactivate_host
      logger.debug "Deactivating host #{name} in PuppetDB"
      return true unless Puppetdb.enabled?

      unless Puppetdb.configured?
        errors.add(:base,
                   _('PuppetDB plugin is enabled but not configured. Please configure it before trying to delete a host.'))
      end

      begin
        Puppetdb.client.deactivate_node(name)
      rescue => e
        errors.add(:base, _("Could not deactivate host on PuppetDB: #{e}"))
        return false
      end
    end
  end
end
