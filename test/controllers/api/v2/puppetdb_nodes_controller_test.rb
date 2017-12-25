require 'test_plugin_helper'

class Api::V2::PuppetdbNodesControllerTest < ActionController::TestCase
  setup do
    setup_settings
    User.current = users(:admin)
    @host = FactoryBot.create(:host, :managed)
  end

  context '#index' do
    test 'lists puppetdb nodes unknown to foreman' do
      ::PuppetdbClient::V4.any_instance.stubs(:query_nodes).returns(['one.example.com', 'two.example.com'])
      get :index, session: set_session_user
      assert_response :success
      response = ActiveSupport::JSON.decode(@response.body)
      hosts = response['results']
      assert_includes hosts, 'name' => 'one.example.com'
      assert_includes hosts, 'name' => 'two.example.com'
    end
  end

  context '#unknown' do
    test 'lists puppetdb nodes unknown to foreman' do
      host = FactoryBot.create(:host, :managed)
      ::PuppetdbClient::V4.any_instance.stubs(:query_nodes).returns([host.name, 'two.example.com'])
      get :unknown, session: set_session_user
      assert_response :success
      response = ActiveSupport::JSON.decode(@response.body)
      hosts = response['results']
      refute_includes hosts, 'name' => host.name
      assert_includes hosts, 'name' => 'two.example.com'
    end
  end

  context '#destroy' do
    let(:node) { 'test.example.com' }
    let(:uuid) { SecureRandom.uuid }

    before do
      ::PuppetdbClient::V4.any_instance.expects(:deactivate_node).with(node).returns(uuid)
    end

    test 'imports a host by puppetdb facts' do
      delete :destroy, params: { :id => node }, session: set_session_user
      assert_response :success
      response = ActiveSupport::JSON.decode(@response.body)
      expected = { 'job' => { 'uuid' => uuid } }
      assert_equal expected, response
    end
  end

  context '#import' do
    let(:node) { 'test.example.com' }
    let(:host) { FactoryBot.create(:host) }

    before do
      ::PuppetdbClient::V4.any_instance.expects(:facts).with(node).returns({})
      PuppetdbHost.any_instance.expects(:to_host).returns(host)
    end

    test 'imports a host by puppetdb facts' do
      put :import, params: { :id => node }, session: set_session_user
      assert_response :success
      response = ActiveSupport::JSON.decode(@response.body)
      assert_equal host.id, response['id']
    end
  end
end
