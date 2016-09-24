require 'test_helper'

class ArchivesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get archives_home_url
    assert_response :success
  end

  test "should get index" do
    get archives_index_url
    assert_response :success
  end

end
