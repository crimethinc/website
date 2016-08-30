require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_users_new_url
    assert_response :success
  end

  test "should get show" do
    get admin_users_show_url
    assert_response :success
  end

  test "should get index" do
    get admin_users_index_url
    assert_response :success
  end

  test "should get create" do
    get admin_users_create_url
    assert_response :success
  end

  test "should get update" do
    get admin_users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_users_destroy_url
    assert_response :success
  end

end
