require "test_helper"

class Api::V1::StudentsStatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student = Student.create!(
      name: "Statistics Student #{SecureRandom.hex(4)}",
      email: "statistics-#{SecureRandom.hex(4)}@example.com",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    @token = SecureRandom.hex(32)

    ApiToken.create!(
      token: @token,
      user_type: "Student",
      user_id: @student.id,
      expires_at: 24.hours.from_now
    )
  end

  test "GET statistics returns student statistics" do
    Student.create!(
      name: "Statistics Student Two #{SecureRandom.hex(4)}",
      email: "statistics-two-#{SecureRandom.hex(4)}@example.com",
      age: 21,
      marks: 60,
      password: "password123",
      password_confirmation: "password123"
    )

    get "/api/v1/students/statistics",
        headers: {
          "Authorization" => "Bearer #{@token}",
          "Accept" => "application/json"
        }

    assert_response :success

    body = JSON.parse(response.body)
    data = body["data"]

    assert data.present?
    assert data["total_students"] >= 2
    assert_equal 80, data["highest_marks"]
    assert_equal 60, data["lowest_marks"]
    assert data["average_marks"].present?
    assert data["passed_students"].present?
    assert data["failed_students"].present?
  end
end
