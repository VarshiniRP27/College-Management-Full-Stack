require "test_helper"

class StudentDashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to student login when not logged in" do
    get student_dashboard_url
    assert_redirected_to student_login_path
  end
end
