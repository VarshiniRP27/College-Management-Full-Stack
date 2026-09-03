require "test_helper"

class TeacherDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to teacher login when not logged in" do
    get teacher_dashboard_url
    assert_redirected_to teacher_login_path
  end
end
