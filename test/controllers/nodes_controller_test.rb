require 'test_plugin_helper'

class NodesControllerTest < ActionController::TestCase
  tests ::PuppetdbForeman::NodesController

  setup do
    setup_settings
    User.current = users(:admin)
    @host = FactoryBot.create(:host, :managed)
  end

  context '#index' do
    test 'lists puppetdb nodes unknown to foreman' do
      host = FactoryBot.create(:host, :managed)
      ::PuppetdbClient::V4.any_instance.stubs(:query_nodes).returns([host.name, 'two.example.com'])
      get :index, session: set_session_user
      assert_response :success
      refute response.body =~ /#{host.name}/m
      assert response.body =~ /two.example.com/m
    end
  end

  context '#show' do
    let(:host) { FactoryBot.create(:host, :managed) }

    before do
      resources_resp = [
        { 'type' => 'Class', 'title' => 'main' },
        { 'type' => 'Class', 'title' => 'Settings' },
        { 'type' => 'Stage', 'title' => 'main' }
      ]

      ::PuppetdbClient::V4.any_instance.stubs(:resources).returns(resources_resp)
    end

    test 'displays puppet classes information about a given node' do
      get :show, params: { id: host.name }, session: set_session_user

      assert_response :success
      assert_includes response.body, '<tr><td>main</td></tr>'
      assert_includes response.body, '<tr><td>Settings</td></tr>'
      assert_includes response.body, '2</span> Classes'
      assert_includes response.body, '2</span> Types'
    end
  end

  context '#destroy' do
    let(:node) { 'test.example.com' }
    test 'deactivating a node in puppetdb' do
      ::PuppetdbClient::V4.any_instance.expects(:deactivate_node).with(node).returns(true)
      delete :destroy, params: { :id => node }, session: set_session_user
      assert_response :found
      assert_redirected_to puppetdb_foreman_nodes_path
      assert_nil flash[:error]
      assert_not_nil flash[:notice] || flash[:success]
      assert_equal "Deactivated node #{node} in PuppetDB", flash[:notice] || flash[:success]
    end
  end

  context '#import' do
    let(:node) { 'test.example.com' }
    let(:host) { FactoryBot.create(:host) }

    before do
      ::PuppetdbClient::V4.any_instance.expects(:facts).with(node).returns({})
      PuppetdbHost.any_instance.expects(:to_host).returns(host)
    end

    test 'imports a host from puppetdb facts' do
      put :import, params: { :id => node }, session: set_session_user
      assert_response :found
      assert_redirected_to host_path(:id => host)
      assert_nil flash[:error]
      assert_not_nil flash[:notice] || flash[:success]
      assert_equal "Imported host #{node} from PuppetDB", flash[:notice] || flash[:success]
    end
  end
end
