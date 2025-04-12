require "test_helper"

class SecretariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get secretaries_index_url
    assert_response :success
  end

  test "should get new" do
    get secretaries_new_url
    assert_response :success
  end

  test "should get create" do
    get secretaries_create_url
    assert_response :success
  end

  test "should get edit" do
    get secretaries_edit_url
    assert_response :success
  end

  test "should get update" do
    get secretaries_update_url
    assert_response :success
  end

  test "should get destroy" do
    get secretaries_destroy_url
    assert_response :success
  end
end
