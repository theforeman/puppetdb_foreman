require 'test_plugin_helper'

class PuppetdbHostTest < ActiveSupport::TestCase
  include FactImporterIsolation
  allow_transactions_for_any_importer

  setup do
    User.current = FactoryBot.create(:user, :admin)
    disable_orchestration
    setup_settings
  end

  let(:sample_facts) do
    JSON.parse(fixture('facts.json'))
  end

  let(:pdbhost) do
    PuppetdbHost.new(:facts => sample_facts)
  end

  test 'parses facts' do
    assert_kind_of HashWithIndifferentAccess, pdbhost.facts
    assert_equal 'host.example.com', pdbhost.certname
    assert_equal 'CEST', pdbhost.facts[:timezone]
    assert_nil pdbhost.environment
  end

  test 'creates a new host by facts' do
    host = pdbhost.to_host
    assert_equal 'host.example.com', host.name
    assert_equal '1.1.1.174', host.ip
    assert_equal Operatingsystem.find_by(title: 'RedHat 7.3'), host.operatingsystem
    assert_equal Domain.find_by(name: 'example.com'), host.domain
  end

  test 'updates an existing host by facts' do
    Setting[:update_subnets_from_facts] = true
    FactoryBot.create(:host, :managed, :hostname => 'host', :domain => FactoryBot.create(:domain, :name => 'example.com'))
    pdbhost.to_host
    host = Host.find_by(name: 'host.example.com')
    assert_equal 'host.example.com', host.name
    # foreman core does not delete old interfaces when importing interfaces from facts
    assert host.interfaces.where(:ip => '1.1.1.174').first
    assert_equal Operatingsystem.find_by(title: 'RedHat 7.3'), host.operatingsystem
  end
end
