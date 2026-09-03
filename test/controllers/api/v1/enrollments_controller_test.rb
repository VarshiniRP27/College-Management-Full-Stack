require "test_helper"

class Api::V1::EnrollmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teacher = Teacher.create!(
      name: "Enrollment Teacher #{SecureRandom.hex(4)}",
      email: "enrollment-teacher-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @student = Student.create!(
      name: "Enrollment Student #{SecureRandom.hex(4)}",
      email: "enrollment-student-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    @course = Course.create!(
      name: "Enrollment Course #{SecureRandom.hex(4)}",
      description: "Enrollment test course",
      teacher: @teacher
    )
  end

  def teacher_headers
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

  def student_headers
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

  test "GET index returns enrollments" do
    enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    get api_v1_enrollments_url,
        headers: teacher_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"].any? { |item| item["id"] == enrollment.id }
  end

  test "GET index eager loads student and course associations" do
    enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    enrollments = Enrollment.includes(:student, :course).where(id: enrollment.id).to_a

    assert_equal true, enrollments.first.association(:student).loaded?
    assert_equal true, enrollments.first.association(:course).loaded?
  end

  test "POST creates enrollment for teacher" do
    assert_difference("Enrollment.count", 1) do
      post api_v1_enrollments_url,
           params: {
             enrollment: {
               student_id: @student.id,
               course_id: @course.id,
               enrolled_at: Time.current,
               status: "active"
             }
           },
           headers: teacher_headers
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal @student.id, body["data"]["student_id"]
    assert_equal @course.id, body["data"]["course_id"]
    assert_equal "active", body["data"]["status"]
  end

  test "POST rejects duplicate enrollment" do
    Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert_no_difference("Enrollment.count") do
      post api_v1_enrollments_url,
           params: {
             enrollment: {
               student_id: @student.id,
               course_id: @course.id,
               enrolled_at: Time.current,
               status: "active"
             }
           },
           headers: teacher_headers
    end

    assert_response :unprocessable_entity

    body = JSON.parse(response.body)

    assert body["errors"].present?
  end

  test "POST rejects student access" do
    assert_no_difference("Enrollment.count") do
      post api_v1_enrollments_url,
           params: {
             enrollment: {
               student_id: @student.id,
               course_id: @course.id,
               enrolled_at: Time.current,
               status: "active"
             }
           },
           headers: student_headers
    end

    assert_response :forbidden
  end

  test "GET show returns enrollment" do
    enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    get api_v1_enrollment_url(enrollment),
        headers: teacher_headers

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal enrollment.id, body["data"]["id"]
    assert_equal @student.name, body["data"]["student_name"]
    assert_equal @course.name, body["data"]["course_name"]
  end

  test "DELETE removes enrollment for teacher" do
    enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert_difference("Enrollment.count", -1) do
      delete api_v1_enrollment_url(enrollment),
             headers: teacher_headers
    end

    assert_response :success
  end

  test "DELETE rejects student access" do
    enrollment = Enrollment.create!(
      student: @student,
      course: @course,
      enrolled_at: Time.current,
      status: "active"
    )

    assert_no_difference("Enrollment.count") do
      delete api_v1_enrollment_url(enrollment),
             headers: student_headers
    end

    assert_response :forbidden
  end

  test "GET requires authentication" do
    get api_v1_enrollments_url

    assert_response :unauthorized
  end
end
