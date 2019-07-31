# frozen_string_literal: true

require 'test_plugin_helper'

class HostTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.build(:user, :admin)
    disable_orchestration
  end

  context 'a host with puppetdb orchestration' do
    let(:host) { FactoryBot.build(:host, :managed) }

    context 'with puppetdb enabled' do
      before do
        Setting[:puppetdb_enabled] = true
      end

      test 'should queue puppetdb destroy' do
        assert_valid host
        host.queue.clear
        host.send(:queue_puppetdb_destroy)
        tasks = host.queue.all.map(&:name)
        assert_includes tasks, "Deactivating node #{host} in PuppetDB"
        assert_equal 1, tasks.size
      end

      test '#del_puppetdb' do
        ::PuppetdbClient::V4.any_instance.expects(:deactivate_node).with(host.certname).returns(true)
        host.send(:del_puppetdb)
      end
    end

    context 'with puppetdb disabled' do
      before do
        Setting[:puppetdb_enabled] = false
      end

      test 'should not queue puppetdb destroy' do
        assert_valid host
        host.queue.clear
        host.send(:queue_puppetdb_destroy)
        tasks = host.queue.all.map(&:name)
        assert_empty tasks
      end
    end
  end
end
