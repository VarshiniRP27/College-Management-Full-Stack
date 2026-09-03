require "test_helper"

class TeachersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get teachers_url
    assert_response :success
  end
end
