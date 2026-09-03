require "test_helper"

class StudentTest < ActiveSupport::TestCase
  test "valid student" do
    student = Student.new(
      name: "Test Student",
      email: "student-test@example.com",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    assert student.valid?
  end

  test "requires name" do
    student = Student.new(
      email: "student-test@example.com",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not student.valid?
    assert_includes student.errors[:name], "can't be blank"
  end

  test "requires email" do
    student = Student.new(
      name: "Test Student",
      age: 20,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not student.valid?
    assert_includes student.errors[:email], "can't be blank"
  end

  test "age must be greater than zero" do
    student = Student.new(
      name: "Test Student",
      email: "student-test@example.com",
      age: 0,
      marks: 80,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not student.valid?
    assert student.errors[:age].any?
  end

  test "marks must be between zero and one hundred" do
    student = Student.new(
      name: "Test Student",
      email: "student-test@example.com",
      age: 20,
      marks: 101,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not student.valid?
    assert student.errors[:marks].any?
  end

  test "result returns PASS for marks 40 or above" do
    student = Student.new(
      name: "Test Student",
      email: "student-test@example.com",
      age: 20,
      marks: 40,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "PASS", student.result
  end

  test "result returns FAIL for marks below 40" do
    student = Student.new(
      name: "Test Student",
      email: "student-test@example.com",
      age: 20,
      marks: 39,
      password: "password123",
      password_confirmation: "password123"
    )

    assert_equal "FAIL", student.result
  end
end
