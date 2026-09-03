require "test_helper"

class Api::V1::StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = Student.create!(
      name: "API Test Student",
      email: "api-student-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 85,
      password: "password123",
      password_confirmation: "password123"
    )
  end

  def auth_headers
    token = SecureRandom.hex(32)

    ApiToken.create!(
      token: token,
      user_type: "Student",
      user_id: @student.id,
      expires_at: 24.hours.from_now
    )

    {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json"
    }
  end

  def teacher_headers
    teacher = Teacher.create!(
      name: "Validation Teacher #{SecureRandom.hex(4)}",
      email: "validation-teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    token = SecureRandom.hex(32)

    ApiToken.create!(
      token: token,
      user_type: "Teacher",
      user_id: teacher.id,
      expires_at: 24.hours.from_now
    )

    {
      "Authorization" => "Bearer #{token}",
      "Accept" => "application/json"
    }
  end

  test "GET index returns students with pagination meta" do
    get api_v1_students_url,
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"].is_a?(Array)
    assert_equal 1, body["meta"]["page"]
    assert_equal 10, body["meta"]["per_page"]
    assert body["meta"]["total"] >= 1
  end

  test "GET index supports search" do
    get api_v1_students_url,
        params: { search: "API Test Student" },
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"].any? do |student|
      student["id"] == @student.id
    end
  end

  test "GET index supports minimum marks filter" do
    get api_v1_students_url,
        params: { min_marks: 80 },
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"].all? do |student|
      student["marks"] >= 80
    end
  end

  test "GET show returns own student" do
    get api_v1_student_url(@student),
        headers: auth_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal @student.id, body["data"]["id"]
    assert_equal @student.email, body["data"]["email"]
  end

  test "GET show blocks student from viewing another student" do
    other_student = Student.create!(
      name: "Other Student",
      email: "other-#{SecureRandom.hex(4)}@example.com",
      age: 21,
      marks: 70,
      password: "password123",
      password_confirmation: "password123"
    )

    get api_v1_student_url(other_student),
        headers: auth_headers

    assert_response :forbidden

    body = JSON.parse(response.body)

    assert_equal "Forbidden", body["error"]
  end

  test "POST create requires teacher or admin" do
    post api_v1_students_url,
         params: {
           student: {
             name: "Blocked Student",
             email: "blocked-#{SecureRandom.hex(4)}@example.com",
             age: 20,
             marks: 75,
             password: "password123",
             password_confirmation: "password123"
           }
         },
         headers: auth_headers

    assert_response :forbidden
  end

  test "PATCH own student updates profile" do
    patch api_v1_student_url(@student),
          params: {
            student: {
              name: "Updated API Student",
              age: 22
            }
          },
          headers: auth_headers

    assert_response :success

    @student.reload

    assert_equal "Updated API Student", @student.name
    assert_equal 22, @student.age
  end

  test "PATCH own student cannot change marks" do
    patch api_v1_student_url(@student),
          params: {
            student: {
              marks: 100
            }
          },
          headers: auth_headers

    assert_response :success

    @student.reload

    assert_equal 85, @student.marks
  end

  test "GET requires authentication" do
    get api_v1_students_url

    assert_response :unauthorized

    body = JSON.parse(response.body)

    assert_equal "Authorization token is required", body["error"]
  end

  test "POST create returns validation errors for invalid student" do
    post api_v1_students_url,
         params: {
           student: {
             name: "",
             email: "",
             age: 0,
             marks: 101,
             password: "password123",
             password_confirmation: "password123"
           }
         },
         headers: teacher_headers

    assert_response :unprocessable_entity

    body = JSON.parse(response.body)

    assert body["errors"].present?
    assert body["errors"]["name"].present?
    assert body["errors"]["email"].present?
    assert body["errors"]["age"].present?
    assert body["errors"]["marks"].present?
  end
end
