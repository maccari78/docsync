require "test_helper"

class DebugControllerTest < ActionDispatch::IntegrationTest
  test "should get appointments" do
    get debug_appointments_url
    assert_response :success
  end
end
