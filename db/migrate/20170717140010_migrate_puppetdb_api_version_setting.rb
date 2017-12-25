class MigratePuppetdbApiVersionSetting < ActiveRecord::Migration[4.2]
  def up
    puppetdb_address = Setting.where(:category => 'Setting::Puppetdb', :name => 'puppetdb_address').first.try(:value)
    return unless puppetdb_address

    api_version = URI.parse(puppetdb_address).path.start_with?('/pdb') ? 3 : 1
    setting = Setting.where(:category => 'Setting::Puppetdb', :name => 'puppetdb_api_version').first_or_create
    setting.value = api_version
    setting.save
  end
end
