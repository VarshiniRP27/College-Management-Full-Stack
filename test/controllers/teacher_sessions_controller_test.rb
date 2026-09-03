require "test_helper"

class TeacherSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get teacher_login_url
    assert_response :success
  end
end
