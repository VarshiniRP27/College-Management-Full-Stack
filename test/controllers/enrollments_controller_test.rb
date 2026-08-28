require "test_helper"

class EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get enrollments_index_url
    assert_response :success
  end
end
