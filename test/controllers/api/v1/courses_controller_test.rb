require "test_helper"

class Api::V1::CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = Teacher.create!(
      name: "API Teacher #{SecureRandom.hex(4)}",
      email: "api-teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @course = Course.create!(
      name: "API Course #{SecureRandom.hex(4)}",
      description: "API test course",
      teacher: @teacher
    )
  end

  def auth_headers
    token = SecureRandom.hex(32)

    ApiToken.create!(
      token: token,
      user_type: "Teacher",
      user_id: @teacher.id,
      expires_at: 24.hours.from_now
    )

    {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json"
    }
  end

  test "GET index returns courses with pagination meta" do
    get api_v1_courses_url,
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"].is_a?(Array)
    assert_equal 1, body["meta"]["page"]
    assert_equal 10, body["meta"]["per_page"]
    assert body["meta"]["total"] >= 1
  end

  test "GET show returns course" do
    get api_v1_course_url(@course),
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal @course.id, body["data"]["id"]
    assert_equal @course.name, body["data"]["name"]
  end

  test "POST creates course" do
    assert_difference("Course.count", 1) do
      post api_v1_courses_url,
           params: {
             course: {
               name: "Created API Course #{SecureRandom.hex(4)}",
               description: "Created through API",
               teacher_id: @teacher.id
             }
           },
           headers: auth_headers
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert body["data"]["id"].present?
    assert_equal "Created through API", body["data"]["description"]
  end

  test "PATCH updates course" do
    patch api_v1_course_url(@course),
          params: {
            course: {
              name: "Updated API Course"
            }
          },
          headers: auth_headers

    assert_response :success

    @course.reload

    assert_equal "Updated API Course", @course.name
  end

  test "DELETE removes course" do
    assert_difference("Course.count", -1) do
      delete api_v1_course_url(@course),
             headers: auth_headers
    end

    assert_response :success
  end

  test "POST without authentication is rejected" do
    post api_v1_courses_url,
         params: {
           course: {
             name: "Unauthorized Course"
           }
         }

    assert_response :unauthorized

    body = JSON.parse(response.body)

    assert_equal "Authorization token is required", body["error"]
  end
end
