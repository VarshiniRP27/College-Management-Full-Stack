require "test_helper"

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  test "student registration succeeds" do
    assert_difference("Student.count", 1) do
      post api_v1_auth_register_url,
           params: {
             user_type: "student",
             name: "API Registered Student",
             email: "registered-student-#{SecureRandom.hex(4)}@example.com",
             age: 20,
             marks: 85,
             password: "password123",
             password_confirmation: "password123"
           }
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal "Registration successful", body["data"]["message"]
    assert_equal "Student", body["data"]["user_type"]
  end

  test "teacher registration succeeds" do
    assert_difference("Teacher.count", 1) do
      post api_v1_auth_register_url,
           params: {
             user_type: "teacher",
             name: "API Registered Teacher",
             email: "registered-teacher-#{SecureRandom.hex(4)}@example.com",
             password: "password123",
             password_confirmation: "password123"
           }
    end

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal "Registration successful", body["data"]["message"]
    assert_equal "Teacher", body["data"]["user_type"]
  end

  test "student login returns token" do
    email = "login-student-#{SecureRandom.hex(4)}@example.com"

    student = Student.create!(
      name: "Login Student",
      email: email,
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    post api_v1_auth_login_url,
         params: {
           email: student.email,
           password: "password123"
         }

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"]["token"].present?
    assert_equal "Student", body["data"]["user_type"]
    assert_equal student.id, body["data"]["user_id"]
  end

  test "teacher login returns token" do
    email = "login-teacher-#{SecureRandom.hex(4)}@example.com"

    teacher = Teacher.create!(
      name: "Login Teacher",
      email: email,
      password: "password123",
      password_confirmation: "password123"
    )

    post api_v1_auth_login_url,
         params: {
           email: teacher.email,
           password: "password123"
         }

    assert_response :success

    body = JSON.parse(response.body)

    assert body["data"]["token"].present?
    assert_equal "Teacher", body["data"]["user_type"]
    assert_equal teacher.id, body["data"]["user_id"]
  end

  test "login rejects invalid password" do
    email = "invalid-login-#{SecureRandom.hex(4)}@example.com"

    Student.create!(
      name: "Invalid Login Student",
      email: email,
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    post api_v1_auth_login_url,
         params: {
           email: email,
           password: "wrong-password"
         }

    assert_response :unauthorized

    body = JSON.parse(response.body)

    assert_equal "Invalid username/email or password", body["error"]
  end

  test "registration returns validation errors" do
    post api_v1_auth_register_url,
         params: {
           user_type: "student",
           email: "invalid-#{SecureRandom.hex(4)}@example.com",
           age: 20,
           marks: 80,
           password: "password123",
           password_confirmation: "password123"
         }

    assert_response :unprocessable_entity

    body = JSON.parse(response.body)

    assert body["errors"].present?
    assert body["errors"]["name"].present?
  end
end
