require "test_helper"

class StudentSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get student_login_url
    assert_response :success
  end
end
