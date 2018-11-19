class RemovePuppetdbDashboardAddressSetting < ActiveRecord::Migration[5.2]
  def change
    Setting::Puppetdb.where(name: 'puppetdb_dashboard_address').destroy_all
  end
end
