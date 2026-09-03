require "test_helper"

class EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when admin is not logged in" do
    get enrollments_url
    assert_redirected_to root_path
  end
end
