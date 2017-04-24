require 'test_plugin_helper'

class NodesControllerTest < ActionController::TestCase
  tests ::PuppetdbForeman::NodesController

  setup do
    setup_settings
    User.current = users(:admin)
    @host = FactoryGirl.create(:host, :managed)
  end

  context '#index' do
    test 'lists puppetdb nodes unknown to foreman' do
      host = FactoryGirl.create(:host, :managed)
      ::PuppetdbClient::V3.any_instance.stubs(:query_nodes).returns([host.name, 'two.example.com'])
      get :index, headers: set_session_user
      assert_response :success
      refute response.body =~ /#{host.name}/m
      assert response.body =~ /two.example.com/m
    end
  end

  context '#destroy' do
    let(:node) { 'test.example.com' }
    test 'deactivating a node in puppetdb' do
      ::PuppetdbClient::V3.any_instance.expects(:deactivate_node).with(node).returns(true)
      delete :destroy, params: { :id => node }, headers: set_session_user
      assert_response :found
      assert_redirected_to puppetdb_foreman_nodes_path
      assert_nil flash[:error]
      assert_not_nil flash[:notice]
      assert_equal "Deactivated node #{node} in PuppetDB", flash[:notice]
    end
  end
end
