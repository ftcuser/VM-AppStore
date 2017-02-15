require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get instances_show_url
    assert_response :success
  end

  test "should get start" do
    get instances_start_url
    assert_response :success
  end

  test "should get stop" do
    get instances_stop_url
    assert_response :success
  end

  test "should get destroy" do
    get instances_destroy_url
    assert_response :success
  end

end
