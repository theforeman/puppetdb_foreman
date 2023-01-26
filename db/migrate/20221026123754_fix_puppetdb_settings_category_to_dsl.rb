# frozen_string_literal: true

class FixPuppetdbSettingsCategoryToDsl < ActiveRecord::Migration[6.0]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Setting.where(category: 'Setting::Puppetdb').update_all(category: 'Setting') if column_exists?(:settings, :category)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
